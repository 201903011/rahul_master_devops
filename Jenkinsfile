pipeline {
    agent any

    environment {
        ECR_REGISTRY = '<your_aws_account_id>.dkr.ecr.<region>.amazonaws.com'
        ECR_REPOSITORY = 'node-application'
        IMAGE_TAG = "${env.BUILD_ID}"
        APP_HOST = '<app-host-public-ip>'
        PEM_FILE = '/home/jenkins/.ssh/your-key.pem'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'main', 
                    credentialsId: 'your-ssh-credential-id', 
                    url: 'git@github.com:your-repo.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    echo 'Building Docker Image...'
                    sh '''
                    aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    docker build -t ${ECR_REPOSITORY}:${IMAGE_TAG} .
                    docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to App Host') {
            steps {
                script {
                    echo 'Deploying to App Host...'
                    sh '''
                    ssh -i ${PEM_FILE} root@${APP_HOST} "
                        docker ps | grep ${ECR_REGISTRY}/${ECR_REPOSITORY} && docker stop $(docker ps | grep ${ECR_REGISTRY}/${ECR_REPOSITORY} | awk '{print \$1}') || true
                        docker run -d -p 80:80 ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    "
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
