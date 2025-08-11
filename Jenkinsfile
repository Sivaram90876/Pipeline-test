pipeline {
    agent {
        docker {
            image 'sivaram9087/jenkins-minikube:latest'
            args '--privileged' // required for Minikube and Docker-in-Docker
        }
    }

    stages {
        stage('Check Tools') {
            steps {
                sh 'kubectl version --client'
                sh 'minikube version'
                sh 'helm version'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'echo "Run your build/test steps here"'
            }
        }
    }
}
