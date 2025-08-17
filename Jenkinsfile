pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')  
        DOCKERHUB_USER = "sivaram9087"   // Your DockerHub username
        IMAGE_NAME = "nature-service"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/nature-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    IMAGE_TAG = "${env.BUILD_NUMBER}"
                    sh """
                        docker build -t $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG .
                        docker tag $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG $DOCKERHUB_USER/$IMAGE_NAME:latest
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh """
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker push $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG
                        docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build and push successful: $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG"
            echo "👉 Next step: run 'kubectl set image deployment/nature-deployment nature-container=$DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG' in your Minikube"
        }
        failure {
            echo "❌ Build or push failed"
        }
    }
}
