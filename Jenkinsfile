pipeline {
    agent any // Or a specific agent with Docker installed, e.g., agent { label 'docker-host' }

    environment {
        // Define your Docker Hub username and image name
        DOCKER_HUB_USERNAME = 'sivaram9087' // Replace with your Docker Hub username
        DOCKER_IMAGE_NAME = "pipeline-test-app" // Name of your Docker image
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    def num1 = 10
                    def num2 = 5
                    def sum = num1 + num2
                    def difference = num1 - num2
                    def product = num1 * num2
                    def quotient = num1 / num2

                    echo "Sum: ${sum}"
                    echo "Difference: ${difference}"
                    echo "Product: ${product}"
                    echo "Quotient: ${quotient}"
                }
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    // Define the image tag (using Jenkins BUILD_NUMBER for uniqueness)
                    def dockerImageTag = "${env.DOCKER_HUB_USERNAME}/${env.DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                    def latestDockerImageTag = "${env.DOCKER_HUB_USERNAME}/${env.DOCKER_IMAGE_NAME}:latest"

                    // Build the Docker image
                    echo "Building Docker image: ${dockerImageTag}"
                    def customImage = docker.build("${dockerImageTag}", '.') // '.' means Dockerfile in current directory

                    // Log in to Docker Hub using credentials defined in Jenkins
                    // 'docker-hub-credentials' is the ID you set in Jenkins Credentials
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        // Push the image with the build number tag
                        echo "Pushing Docker image: ${dockerImageTag} to Docker Hub"
                        customImage.push()

                        // Also push it with the 'latest' tag
                        echo "Pushing Docker image: ${latestDockerImageTag} to Docker Hub"
                        customImage.push("latest")
                    }
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                // Add your test commands here (e.g., sh 'npm test')
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // This stage would contain commands to deploy your Docker image
                // For now, it's just a placeholder.
            }
        }
    }
    post {
        always {
            cleanWs() // Clean up workspace after build
        }
        success {
            echo 'Pipeline finished successfully!'
            // You might add a step here to update GitHub commit status to "success"
        }
        failure {
            echo 'Pipeline failed!'
            // You might add a step here to update GitHub commit status to "failure"
        }
    }
}
