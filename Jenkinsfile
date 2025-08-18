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
    }

    post {
        success {
            echo "✅ Build and push successful: $IMAGE_NAME:${BUILD_NUMBER}"
            echo "👉 Now run locally: kubectl rollout restart deployment/nature-deployment"
            echo "👉 And access app with: minikube service nature-service"
        }
        failure {
            echo "❌ Build or push failed"
        }
    }   
}
