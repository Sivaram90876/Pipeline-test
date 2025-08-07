pipeline {
    agent any

    stages {
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
                        // Use sh for shell commands on Linux
                        sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"
                    }

                    sh "docker build -t ${imageName}:${imageTag} ."
                    sh "docker push ${imageName}:${imageTag}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // This is a crucial step to trigger a rolling update
                    // The path needs to be a Linux path, and the command must be sh
                    // Using sed for in-place text replacement
                    sh "sed -i 's|image: sivaram9087/nature:.*|image: sivaram9087/nature:latest|g' deployment.yaml"
                    
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl rollout status deployment/nature"
                }
            }
        }
    }
}
