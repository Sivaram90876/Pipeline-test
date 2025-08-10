pipeline {
    agent any

    environment {
        KUBECONFIG = "/root/.kube/config"
        DOCKER_DRIVER = "docker"
    }

    stages {
        stage('Install Tools') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release
                    # Install Docker
                    curl -fsSL https://get.docker.com | sh
                    # Install Kubectl
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
                    # Install Minikube
                    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                    install minikube-linux-amd64 /usr/local/bin/minikube
                '''
            }
        }

        stage('Start Minikube') {
            steps {
                sh '''
                    echo "Starting Minikube with Docker driver..."
                    minikube start --driver=${DOCKER_DRIVER}
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t my-app:latest .
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    echo "Deploying to Kubernetes..."
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }
    }
}
