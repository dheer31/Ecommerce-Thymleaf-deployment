pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['Deploy', 'Remove'],
            description: 'Deploy or Remove application'
        )
    }

    stages {

        stage('Docker Compose Deploy') {
            when {
                expression { params.ACTION == 'Deploy' }
            }
            steps {
                echo "🚀 Building and starting Spring Boot & MySQL containers..."
                sh '''
                   docker-compose up -d --build
                '''
            }
        }

        stage('Docker Compose Remove & Cleanup') {
            when {
                expression { params.ACTION == 'Remove' }
            }
            steps {
                echo "🧹 Cleaning Docker resources..."
                sh '''
                docker compose down --rmi all --volumes --remove-orphans
                docker system prune -af
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline executed successfully! - Designed and Developed by dhee31"
        }
        failure {
            echo "❌ Pipeline failed. Check Jenkins logs! - Designed and Developed by dhee31"
        }
    }
}
