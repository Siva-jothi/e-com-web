pipeline {
    agent any

    environment {
        DOCKER_DEV = "sivacs2004/dev"
        DOCKER_PROD = "sivacs2004/prod"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Print Branch') {
            steps {
                echo "Branch Name: ${env.GIT_BRANCH}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_DEV:latest .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-cred',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push to DEV Repo') {
            when {
                expression { env.GIT_BRANCH.contains("dev") }
            }
            steps {
                sh 'docker push $DOCKER_DEV:latest'
            }
        }

        stage('Push to PROD Repo') {
            when {
                expression { env.GIT_BRANCH.contains("main") }
            }
            steps {
                sh '''
                docker tag $DOCKER_DEV:latest $DOCKER_PROD:latest
                docker push $DOCKER_PROD:latest
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
            }
        }
    }
}
