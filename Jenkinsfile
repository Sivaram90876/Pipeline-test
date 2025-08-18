pipeline {
    agent any

    environment {
        IMAGE_NAME = "sivaram9087/nature-service"
        DEPLOYMENT_NAME = "nature-deployment"
        CONTAINER_NAME = "nature-container"
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
                withCredentials([usernamePassword(credentialsId: 'Dockerhub_credentials',
                                                 usernameVariable: 'DOCKERHUB_USER',
                                                 passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh """
                    echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    docker build -t $IMAGE_NAME:${BUILD_NUMBER} -f dockerfile .
                    docker tag $IMAGE_NAME:${BUILD_NUMBER} $IMAGE_NAME:latest
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                docker push $IMAGE_NAME:${BUILD_NUMBER}
                docker push $IMAGE_NAME:latest
                """
            }
        }

        stage('Deploy to Minikube') {
            steps {
                sh """
                echo "🚀 Restarting deployment to pick up latest image..."
                kubectl rollout restart deployment/$DEPLOYMENT_NAME
                """
            }
        }
    }

    post {
        success {
            echo "✅ Build, push, and rollout restart successful!"
            echo "👉 Deployment $DEPLOYMENT_NAME is now running the latest image."
        }
        failure {
            echo "❌ Build, push, or deploy failed"
        }
    }
}
