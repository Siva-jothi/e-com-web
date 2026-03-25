pipeline {
    agent any

    environment {
        DOCKER_USER = "sivacs2004"
        DEV_IMAGE = "sivacs2004/dev:latest"
        PROD_IMAGE = "sivacs2004/prod:latest"
    }

    stages {

        stage('Clone Code') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/Siva-jothi/e-com-web.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DEV_IMAGE .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push to DEV Repo') {
            when {
                branch 'dev'
            }
            steps {
                sh 'docker push $DEV_IMAGE'
            }
        }

        stage('Push to PROD Repo') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                docker tag $DEV_IMAGE $PROD_IMAGE
                docker push $PROD_IMAGE
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}
