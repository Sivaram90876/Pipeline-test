pipeline {
    agent any

    environment {
        IMAGE_NAME = "sivaram9087/nature-service"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'nature-pipeline',
                    url: 'https://github.com/Sivaram90876/Pipeline-test.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                powershell """
                docker build -t $IMAGE_NAME:${BUILD_NUMBER} .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                powershell """
                docker push $IMAGE_NAME:${BUILD_NUMBER}
                """
            }
        }

        stage('Deploy to Minikube') {
            steps {
                powershell """
                kubectl set image deployment/nature-deployment nature-container=$IMAGE_NAME:${BUILD_NUMBER}
                kubectl rollout status deployment/nature-deployment
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
