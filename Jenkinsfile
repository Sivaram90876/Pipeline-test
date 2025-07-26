pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'sivaram9087' // Your Docker Hub username
        DOCKER_IMAGE_NAME = "pipeline-test-app" // Your Docker image name
        DOCKER_CREDENTIALS_ID = 'Docker_credentials' // Your Jenkins credential ID for Docker Hub
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                echo 'Build step handled by Dockerfile. No manual build here.'
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    def dockerImageTag = "${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"
                    def latestDockerImageTag = "${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:latest"

                    echo "Building Docker image: ${dockerImageTag}"
                    def customImage = docker.build(dockerImageTag, '.')

                    echo "Logging into Docker Hub..."
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        echo "Pushing Docker image: ${dockerImageTag}"
                        customImage.push()

                        echo "Pushing Docker image: ${latestDockerImageTag}"
                        customImage.push("latest")
                    }
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                // Optional: Add test steps like sh 'npm test' if needed
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // Add deployment logic here (e.g., kubectl, SSH to server, etc.)
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished! Cleaning up...'

            // Optional cleanup: remove local Docker images if Jenkins agent is persistent
            sh "docker rmi ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG} || true"
            sh "docker rmi ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:latest || true"
        }
    }
}
