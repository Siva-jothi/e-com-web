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

        stage('Detect Branch') {
            steps {
                script {
                    env.GIT_BRANCH_NAME = sh(
                        script: "git rev-parse --abbrev-ref HEAD",
                        returnStdout: true
                    ).trim()
                    echo "Current Branch: ${env.GIT_BRANCH_NAME}"
                }
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
                expression { env.GIT_BRANCH_NAME == 'dev' }
            }
            steps {
                sh 'docker push $DOCKER_DEV:latest'
            }
        }

        stage('Push to PROD Repo') {
            when {
                expression { env.GIT_BRANCH_NAME == 'main' }
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
