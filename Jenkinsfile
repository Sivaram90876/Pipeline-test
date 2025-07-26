pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'sivaram9087'                 // Your Docker Hub username
        DOCKER_IMAGE_NAME = "pipeline-test-app"             // Docker image name
        DOCKER_CREDENTIALS_ID = 'Docker_credentials'        // Jenkins credential ID
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
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    def dockerImageTag = "${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    def latestDockerImageTag = "${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:latest"

                    echo "Building Docker image: ${dockerImageTag}"
                    def customImage = docker.build(dockerImageTag, '.')

                    echo "Logging in to Docker Hub and pushing images..."
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        customImage.push()
                        customImage.push("latest")
                    }
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'npm test' // Make sure you define this in package.json
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // Add deployment logic here: ssh, Kubernetes, etc.
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished! Cleaning up...'
            // Optional cleanup:
            sh "docker rmi ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} || true"
            sh "docker rmi ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:latest || true"
        }
    }
}
