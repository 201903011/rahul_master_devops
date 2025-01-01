pipeline {
    agent any

    environment {
        ECR_REGISTRY = '897540928180.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'node-app'
        IMAGE_TAG = "${env.BUILD_ID}"
        APP_HOST = '10.0.4.4'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'master', 
                    credentialsId: '824777fb-b1d6-4a15-a375-ef6a3d331ecf', 
                    url: 'git@github.com:201903011/rahul_master_devops.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    echo 'Building Docker Image...'
                    sh '''
                    cd app
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_REGISTRY}
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
                    withCredentials([file(credentialsId: '1b71379b-b6a5-4824-91e9-ae324674ae78', variable: 'PEM_FILE')]) {
                        sh '''
                        dir
                        PEM_FILE
                        chmod 400 ${PEM_FILE}
                        ssh -i ${PEM_FILE}  root@${APP_HOST}
                        sudo docker ps | grep ${ECR_REGISTRY}/${ECR_REPOSITORY} && docker stop $(docker ps | grep ${ECR_REGISTRY}/${ECR_REPOSITORY} | awk '{print \$1}') || true
                        sudo docker run -d -p 80:80 ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                        "
                        '''
                    }
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
