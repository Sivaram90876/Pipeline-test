pipeline {
    agent any
    
    stages {
        stage('Install Tools') {
            steps {
                sh '''
                    # Install Minikube CLI
                    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                    sudo install minikube-linux-amd64 /usr/local/bin/minikube
                    
                    # Install kubectl
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
                '''
            }
        }
        
        stage('Checkout') {
            steps {
                echo "Checking out code from Git..."
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

                    // Use docker buildx build with --push to handle platforms correctly
                    sh "docker buildx build --platform linux/amd64 -t ${imageName}:${imageTag} . --push"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "sed -i 's|image: sivaram9087/nature:.*|image: sivaram9087/nature:latest|g' deployment.yaml"
                    
                    // Use minikube kubectl wrapper to connect to the cluster
                    sh "minikube kubectl -- apply -f deployment.yaml"
                    
                    sh "minikube kubectl -- rollout status deployment/nature"
                }
            }
        }
    }
}
