pipeline {
    agent any

    environment {
        DOCKER_USER = "sivacs2004"
        DEV_IMAGE = "sivacs2004/dev:latest"
        PROD_IMAGE = "sivacs2004/prod:latest"
    }

    stages {

       
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DEV_IMAGE .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push to DEV Repo') {
            when {
                expression { env.BRANCH_NAME == 'dev' }
            }
            steps {
                sh 'docker push $DEV_IMAGE'
            }
        }

        stage('Push to PROD Repo') {
            when {
                expression { env.BRANCH_NAME == 'main' }
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
