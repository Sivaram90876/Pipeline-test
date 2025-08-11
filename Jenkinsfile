pipeline {
    agent {
        docker {
            image 'sivaram9087/jenkins-minikube:latest'
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
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

        stage('Deploy Sample App') {
            steps {
                sh '''
                echo "Deploying a sample Nginx app..."
                kubectl create deployment nginx --image=nginx || true
                kubectl expose deployment nginx --port=80 --type=NodePort || true
                kubectl get all
                '''
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
