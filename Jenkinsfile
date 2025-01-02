pipeline {
    agent any

    environment {
        ECR_REGISTRY = '897540928180.dkr.ecr.us-east-1.amazonaws.com/node-app'
        ECR_REPOSITORY = 'node-app'
        IMAGE_TAG = "${env.BUILD_ID}"
        APP_HOST = '10.0.4.112'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'master', 
                    credentialsId: 'e61abb13-5825-4ba1-abfe-464dfb4210a2', 
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
                    withCredentials([file(credentialsId: '3efe91f3-5153-4202-8fbe-72a9d961b70d', variable: 'PEM_FILE')]) {
                        sh '''
                        dir
                        chmod 400 ${PEM_FILE}
                        ssh -i ${PEM_FILE}  ubuntu@${APP_HOST} <<EOF
                            dir
                            aws ecr get-login-password --region us-east-1 |sudo docker login --username AWS --password-stdin ${ECR_REGISTRY}
                            sudo docker stop $(sudo docker ps -q)
                            sudo docker rm $(sudo docker ps -a -q)
                            sudo docker pull  ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                            sudo docker run -itd -p 80:80 ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                            sudo docker ps
                            exit
                        EOF
                        
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
