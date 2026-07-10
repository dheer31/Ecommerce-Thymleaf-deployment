pipeline {

    agent any

    environment {
        IMAGE_NAME = "springboot-app"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Verify Image') {
            steps {
                sh "docker images | grep ${IMAGE_NAME}"
            }
        }

        stage('Run Container') {
            steps {
                sh """
                    docker stop springboot-container || true
                    docker rm springboot-container || true

                    docker run -d \
                    --name springboot-container \
                    -p 8081:8081 \
                    ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }

    post {
        success {
            echo "Docker Image Built Successfully!"
        }

        failure {
            echo "Build Failed!"
        }

        always {
            sh "docker ps -a"
        }
    }
}
