pipeline {
    agent any

    environment {
        IMAGE_NAME = "sivaram9087/nature-service"
        LOCAL_PATH = "C:\\Users\\HP\\Pipeline-test"
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

        stage('Sync Code to Local Path') {
            steps {
                bat """
                cd %LOCAL_PATH%
                if exist .git (
                    git reset --hard
                    git pull origin nature-pipeline
                ) else (
                    git clone -b nature-pipeline https://github.com/Sivaram90876/Pipeline-test.git %LOCAL_PATH%
                )
                """
            }
        }
    }

    post {
        success {
            echo "✅ Build & push successful: $IMAGE_NAME:${BUILD_NUMBER}"
            echo "📂 Repo synced to: $LOCAL_PATH"
            echo "👉 Now run: kubectl rollout restart deployment/nature-deployment && minikube service nature-service"
        }
        failure {
            echo "❌ Build or push failed"
        }
    }
}
