pipeline {
    agent {
        docker {
            image 'debian:stable'
            args '--user 0'
        }
    }
    options {
        disableConcurrentBuilds()
    }
    environment {
        PATH = "${env.PATH}:/usr/local/bin"
    }
    stages {
        stage('Install Tools') {
            steps {
                sh '''
                    set -e
                    echo "--- Installing base packages ---"
                    apt-get update
                    apt-get install -y \
                        curl \
                        gettext-base \
                        iptables \
                        git \
                        docker.io \
                        conntrack \
                        socat \
                        unzip
                    
                    echo "--- Installing Minikube ---"
                    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                    chmod +x minikube-linux-amd64
                    mv minikube-linux-amd64 /usr/local/bin/minikube
                    
                    echo "--- Installing kubectl ---"
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    chmod +x kubectl
                    mv kubectl /usr/local/bin/kubectl
                    
                    echo "--- Installing crictl ---"
                    CRICTL_VERSION="v1.30.0"
                    CRICTL_URL="https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz"
                    curl -L ${CRICTL_URL} | tar zx
                    chmod +x crictl
                    mv crictl /usr/local/bin/crictl

                    echo "--- Installing cri-dockerd ---"
                    CRI_DOCKERD_VERSION="0.3.14"
                    curl -L "https://github.com/Mirantis/cri-dockerd/releases/download/v${CRI_DOCKERD_VERSION}/cri-dockerd-${CRI_DOCKERD_VERSION}.amd64.tgz" | tar zx
                    mv cri-dockerd/cri-dockerd /usr/local/bin/cri-dockerd
                    chmod +x /usr/local/bin/cri-dockerd

                    echo "--- Installing CNI plugins ---"
                    CNI_PLUGIN_VERSION="v1.4.0"
                    CNI_PLUGIN_TAR="cni-plugins-linux-amd64-$CNI_PLUGIN_VERSION.tgz"
                    CNI_PLUGIN_INSTALL_DIR="/opt/cni/bin"
                    
                    curl -LO "https://github.com/containernetworking/plugins/releases/download/$CNI_PLUGIN_VERSION/$CNI_PLUGIN_TAR"
                    mkdir -p "$CNI_PLUGIN_INSTALL_DIR"
                    tar -xf "$CNI_PLUGIN_TAR" -C "$CNI_PLUGIN_INSTALL_DIR"
                    rm "$CNI_PLUGIN_TAR"
                '''
            }
        }
        
        stage('Checkout') {
            steps {
                echo "Checking out code from Git..."
            }
        }

        stage('Start Minikube Cluster') {
            steps {
                sh 'minikube start --driver=none'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def imageName = "sivaram9087/nature"
                    def imageTag = "latest"

                    withCredentials([usernamePassword(credentialsId: 'Dockerhub_credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"
                    }
                    sh "docker buildx build --platform linux/amd64 -t ${imageName}:${imageTag} . --push"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "sed -i 's|image: sivaram9087/nature:.*|image: sivaram9087/nature:latest|g' deployment.yaml"
                    sh "minikube kubectl -- apply -f deployment.yaml"
                    sh "minikube kubectl -- rollout status deployment/nature"
                }
            }
        }
    }
}
