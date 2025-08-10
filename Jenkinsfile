pipeline {
    agent {
        docker {
            image 'debian:stable'
            // Use --privileged to grant the container root-level access
            args '--privileged'
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
                        unzip \
                        sudo
                    
                    echo "--- Installing Minikube ---"
                    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                    chmod +x minikube-linux-amd64
                    mv minikube-linux-amd64 /usr/local/bin/minikube
                    
                    echo "--- Installing kubectl ---"
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    chmod +x kubectl
                    mv kubectl /usr/local/bin/kubectl
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
                // Use the docker driver instead of none
                sh 'minikube start --driver=docker'
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
