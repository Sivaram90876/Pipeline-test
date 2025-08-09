pipeline {
    agent any
    
    environment {
        PATH = "${env.PATH}:${env.HOME}/.local/bin"
    }

    stages {
        stage('Install Tools') {
            steps {
                sh '''
                    mkdir -p $HOME/.local/bin
                    
                    # Install Minikube
                    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                    chmod +x minikube-linux-amd64
                    mv minikube-linux-amd64 $HOME/.local/bin/minikube
                    
                    # Install kubectl
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    chmod +x kubectl
                    mv kubectl $HOME/.local/bin/kubectl
                    
                    # Install iptables, required for Minikube with --driver=none
                    sudo apt-get update && sudo apt-get install -y iptables
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
