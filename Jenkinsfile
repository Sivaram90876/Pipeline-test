pipeline {
    agent {
        docker {
            image 'debian:stable'
            args '--privileged --user root --network host'
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
                        socat

                    echo "--- Installing Minikube ---"
                    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                    install minikube-linux-amd64 /usr/local/bin/minikube
                    rm minikube-linux-amd64

                    echo "--- Installing Kubectl ---"
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    install kubectl /usr/local/bin/kubectl
                    rm kubectl
                '''
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Start Minikube Cluster') {
            steps {
                sh 'minikube start --driver=docker --force'
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
                sh '''
                    sed -i 's|image: sivaram9087/nature:.*|image: sivaram9087/nature:latest|g' deployment.yaml
                    minikube kubectl -- apply -f deployment.yaml
                    minikube kubectl -- rollout status deployment/nature
                '''
            }
        }
    }
}
