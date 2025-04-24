pipeline {
    agent any

    environment {
        IMAGE_NAME = "gerronc/static-web"
        TAG = "${BUILD_NUMBER}"  // Unique tag per build
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
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    dockerImage.push()
                    // Optional: update 'latest' tag too
                    dockerImage.push("latest")
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sshagent(['ec2-ssh-creds']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@<EC2-IP-ADDRESS> '
                            docker pull ${IMAGE_NAME}:${TAG} &&
                            docker rm -f static-web || true &&
                            docker run -d -p 80:80 --name static-web ${IMAGE_NAME}:${TAG}
                        '
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Deployment succeeded! App is live."
        }
        failure {
            echo "Build or deployment failed. Check logs for errors."
        }
    }
}
