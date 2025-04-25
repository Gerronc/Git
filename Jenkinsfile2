pipeline {
    agent any  // Runs on any available agent

    environment {
        DOCKER_IMAGE = "kbhola001/simple-webpage"
        DOCKER_CREDENTIALS = "docker-hub-credentials"  // Stored in Jenkins credentials
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/kestonbhola/moregithublessons.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry-1.docker.io/v2/', DOCKER_CREDENTIALS) {
                        echo "You are logged in to Docker Hub"
                    }
                }
            }
        }

        stage('Push Image to Docker Hub') {
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
                    // Cleanup unused Docker images to free space
                    sh "docker image prune -f"
                    
                    // Stop running container (if exists)
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
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
