pipeline {
    agent {
        docker {
            image 'sivaram9087/jenkins-minikube:latest'
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        // Set your Docker Hub username here
        DOCKER_HUB_USER = 'sivaram9087'
        // Create a unique tag for the Docker image
        IMAGE_TAG = "v${env.BUILD_NUMBER}" 
        DOCKER_IMAGE = "${DOCKER_HUB_USER}/nature:${IMAGE_TAG}"
    }

    stages {
        stage('Check Environment') {
            steps {
                sh 'echo "User: $(whoami)"'
                sh 'docker --version'
                sh 'kubectl version --client'
                sh 'minikube version'
                sh 'helm version'
            }
        }

        stage('Start Minikube') {
            steps {
                sh '''
                echo "Starting Minikube..."
                minikube start --driver=docker
                kubectl get nodes
                '''
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                // Ensure you have configured Docker Hub credentials in Jenkins
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Apply the deployment with the new image tag
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f service.yaml"
                sh "kubectl apply -f ingress.yaml"
                sh "kubectl get all"
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl get pods -o wide'
                sh 'kubectl get svc -o wide'
            }
        }
    }

    post {
        always {
            sh 'echo "Stopping Minikube..."'
            sh 'minikube stop || true'
        }
    }
}
