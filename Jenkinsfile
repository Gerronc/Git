pipeline {
    agent any

    environment {
        IMAGE_NAME = "gerronc/simple-webpage"
        TAG = "${BUILD_NUMBER}"  // Unique tag per build
    }

    stages {
        stage('Checkout') {
            steps {
                // Ensure the correct branch is checked out (main instead of master)
                git branch: 'main', url: 'https://github.com/Gerronc/Git.git'
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
                    dockerImage.push("latest")  // Optional: update latest tag
                }
            }
        }

        stage
