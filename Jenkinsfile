pipeline {
    agent {
        docker {
            image 'sivaram9087/jenkins-minikube:latest'
            // This is the critical line that lets the container talk to the host's Docker daemon.
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        // Set your Docker Hub username here
        DOCKER_HUB_USER = 'sivaram9087'
        // Use a unique tag for the Docker image
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
        DOCKER_IMAGE = "${DOCKER_HUB_USER}/nature:${IMAGE_TAG}"
    }

    stages {
        stage('Check Environment') {
            steps {
                sh 'echo "User: $(whoami)"'
                // This command should now succeed
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
                // Note: your deployment.yaml references 'sivaram9087/nature:latest'
                // You should update it to use the dynamic tag. A cleaner approach is to use a sed command:
                sh "sed -i 's|sivaram9087/nature:latest|${DOCKER_IMAGE}|' deployment.yaml"
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
