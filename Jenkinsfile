pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_URI = "992382545251.dkr.ecr.us-east-1.amazonaws.com/status-page"
        EKS_CLUSTER = "dr_statuspage_cluster"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/cicd-setup']],
                          userRemoteConfigs: [[
                              url: 'https://github.com/missviee/status-page-final-workshop.git',
                              credentialsId: 'github-token'
                          ]]
                ])
            }
        }

        stage('Build & Push Docker') {
            steps {
                sh '''
                  IMAGE_TAG=$(git rev-parse --short HEAD)
                  aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $(echo $ECR_URI | cut -d'/' -f1)
                  docker build -t $ECR_URI:$IMAGE_TAG .
                  docker push $ECR_URI:$IMAGE_TAG
                  echo "IMAGE=$ECR_URI:$IMAGE_TAG" > build.env
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh '''
                      source build.env
                      aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER
                      kubectl -n status-page set image deployment/status-page status-page=$IMAGE || kubectl -n status-page apply -f k8s/
                      kubectl -n status-page rollout status deployment/status-page --timeout=120s
                    '''
                }
            }
        }
    }
}

