pipeline {
    agent any

    environment {
        IMAGE_NAME = "gerronc/static-web"
        TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Gerronc/Git.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    dockerImage.push()
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                script {
                    sh 'docker rm -f static-web || true'
                    sh 'docker run -d -p 80:80 --name static-web ${IMAGE_NAME}:${TAG}'
                }
            }
        }
    }
}
