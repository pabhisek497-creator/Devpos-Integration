pipeline {
    agent any

    tools {
        // Use Gradle installed in Jenkins
        gradle 'Gradle_8'
    }

    environment {
        // DockerHub credentials ID (the one you added in Jenkins)
        DOCKERHUB_CREDENTIALS = credentials('docker-hub')

        // Change this to your DockerHub username and repo name
        IMAGE_NAME = "pradhanabhisek/devops-integration"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📦 Checking out code from GitHub..."
                checkout scm
            }
        }

        stage('Build with Gradle') {
            steps {
                echo "⚙️ Building project using Gradle..."
                bat 'gradlew clean build'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                bat "docker build -t %IMAGE_NAME%:latest ."
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                echo "📤 Pushing Docker image to DockerHub..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker push %IMAGE_NAME%:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully — Image pushed to DockerHub!"
        }
        failure {
            echo "❌ Pipeline failed. Please check console logs."
        }
    }
}
