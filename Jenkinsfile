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

                    withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKERHUB_PASSWORD'), string(credentialsId: 'dockerhub-username', variable: 'DOCKERHUB_USERNAME')]) {
                        bat "docker login -u %DOCKERHUB_USERNAME% -p %DOCKERHUB_PASSWORD%"
                    }

                    bat "docker build -t ${imageName}:${imageTag} ."
                    bat "docker push ${imageName}:${imageTag}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    bat """
                        powershell -Command "(Get-Content 'C:\\Users\\HP\\Pipeline-test\\deployment.yaml') -replace 'image: sivaram9087/nature:.*', 'image: sivaram9087/nature:latest' | Set-Content 'C:\\Users\\HP\\Pipeline-test\\deployment.yaml'"
                    """
                    bat "kubectl apply -f C:\\Users\\HP\\Pipeline-test\\deployment.yaml"
                    bat "kubectl rollout status deployment/nature"
                }
            }
        }
    }
}
