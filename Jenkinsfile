pipeline {
    agent any  // Can specify label if needed, e.g., agent { label 'docker' }

    options {
        timestamps()
        ansiColor('xterm')
    }

    environment {
        DOCKER_IMAGE = "gerronc/simple-webpage"
        DOCKER_CREDENTIALS = "docker-hub-creds"  // Must match ID in Jenkins credentials
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Gerronc/Git.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:latest", ".")
                }
            }
        }

        stage('Login and Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        docker.image("${DOCKER_IMAGE}:latest").push()
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // Clean up unused images to save space
                    sh "docker image prune -f"

                    // Stop and remove existing container (ignore errors)
                    sh "docker stop my-webpage-container || true"
                    sh "docker rm my-webpage-container || true"

                    // Run the new container
                    sh "docker run -d --name my-webpage-container -p 80:80 ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed. Check the logs for details.'
        }
    }
}
