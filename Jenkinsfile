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
                    sudo apt-get update
                    sudo apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release
                    # Install Docker
                    curl -fsSL https://get.docker.com | sudo sh
                    # Install Kubectl
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
                    # Install Minikube
                    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                    sudo install minikube-linux-amd64 /usr/local/bin/minikube
                '''
            }
        }

        stage('Start Minikube') {
            steps {
                sh '''
                    echo "Starting Minikube with Docker driver..."
                    sudo minikube delete || true
                    sudo minikube start --driver=${DOCKER_DRIVER} --force
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
