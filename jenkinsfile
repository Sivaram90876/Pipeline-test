pipeline {
    agent any

    tools {
        // You can define tools here if you installed them via Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                // Jenkins automatically checks out the code
                echo "Checking out code from Git..."
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Define image name and tag
                    def imageName = "sivaram9087/nature"
                    def imageTag = "latest" // Or use a build number: "build-${env.BUILD_NUMBER}"

                    // Login to Docker Hub
                    withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKERHUB_PASSWORD'), string(credentialsId: 'dockerhub-username', variable: 'DOCKERHUB_USERNAME')]) {
                        bat "docker login -u %DOCKERHUB_USERNAME% -p %DOCKERHUB_PASSWORD%"
                    }

                    // Build the Docker image
                    bat "docker build -t ${imageName}:${imageTag} ."

                    // Push the image to Docker Hub
                    bat "docker push ${imageName}:${imageTag}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update the Kubernetes deployment with the new image tag
                    // This is a crucial step to trigger a rolling update
                    // The path needs to be correct for your Windows file system
                    bat """
                        powershell -Command "(Get-Content 'C:\\Users\\HP\\Pipeline-test\\deployment.yaml') -replace 'image: sivaram9087/nature:.*', 'image: sivaram9087/nature:latest' | Set-Content 'C:\\Users\\HP\\Pipeline-test\\deployment.yaml'"
                    """

                    // Apply the new configuration to the Kubernetes cluster
                    bat "kubectl apply -f C:\\Users\\HP\\Pipeline-test\\deployment.yaml"

                    // Wait for the deployment to finish
                    bat "kubectl rollout status deployment/nature"
                }
            }
        }
    }
}
