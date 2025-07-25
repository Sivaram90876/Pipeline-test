pipeline {
    agent any

    environment {
        DOCKER_HUB_USERNAME = 'sivaram9087' // Your Docker Hub username
        DOCKER_IMAGE_NAME = "pipeline-test-app" // Your Docker image name
        DOCKER_CREDENTIALS_ID = 'Docker_credentials' // ID of your Jenkins credentials
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Application') { // Renamed for clarity, assuming app build here
            steps {
                // *** IMPORTANT ***
                // Replace this with your actual application build steps, e.g.:
                // sh 'npm install'
                // sh 'mvn clean package'
                // If your Dockerfile handles all building, you might just have:
                echo 'Application build step (if any) complete or handled by Dockerfile.'
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    def dockerImageTag = "${env.DOCKER_HUB_USERNAME}/${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                    def latestDockerImageTag = "${env.DOCKER_HUB_USERNAME}/${env.DOCKER_IMAGE_NAME}:latest"

                    echo "Building Docker image: ${dockerImageTag}"
                    def customImage = docker.build("${dockerImageTag}", '.')

                    echo "Logging in to Docker Hub..."
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        echo "Pushing Docker image: ${dockerImageTag} to Docker Hub"
                        customImage.push()

                        echo "Pushing Docker image: ${latestDockerImageTag} to Docker Hub"
                        customImage.push("latest")
                    }
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                // Add your actual test commands here (e.g., sh 'npm test')
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // This stage would contain commands to deploy your Docker image
                // This is where you'd add SSH commands, Kubernetes, etc.
            }
        }
    }

    post {
        always {
            steps { // <--- ADDED
                // docker logout is typically handled by docker.withRegistry scope exit,
                // but can be explicit if needed (uncomment below)
                // sh 'docker logout || true'
                cleanWs() // Clean up workspace after build - good practice
            } // <--- ADDED
        }
        success {
            steps { // <--- ADDED
                echo 'Pipeline finished successfully! Image pushed to Docker Hub.'
            } // <--- ADDED
        }
        failure {
            steps { // <--- ADDED
                echo 'Pipeline failed! Check build logs for errors.'
            } // <--- ADDED
        }
    }
}
