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
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                docker push $IMAGE_NAME:${BUILD_NUMBER}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl set image deployment/nature-deployment nature-container=$IMAGE_NAME:${BUILD_NUMBER} --record
                kubectl rollout status deployment/nature-deployment
                """
            }
        }
    }

    post {
        success {
            echo "✅ Successfully deployed $IMAGE_NAME:${BUILD_NUMBER}"
        }
        failure {
            echo "❌ Build/Push/Deploy failed"
        }
    }
}
