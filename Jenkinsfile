pipeline {
    agent any  // run on any Jenkins agent

    environment {
        AWS_REGION = "us-east-1"
        ECR_URI = "992382545251.dkr.ecr.us-east-1.amazonaws.com/statuspage-placeholder"
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

        stage('Build & Push Docker (Placeholder)') {
            steps {
                sh '''
                  echo "=== Simulating Docker build and push ==="
                  IMAGE_TAG=$(git rev-parse --short HEAD)
                  echo "Would build and push: $ECR_URI:$IMAGE_TAG"
                  echo "IMAGE=$ECR_URI:$IMAGE_TAG" > build.env
                '''
            }
        }

        stage('Deploy to EKS (Placeholder)') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh '''
                      . build.env
                      echo "=== Deploying placeholder app to EKS cluster $EKS_CLUSTER in $AWS_REGION ==="
                      aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER
                      
                      # Apply placeholder manifests instead of real app
                      kubectl -n status-page apply -f k8s/statuspage-placeholder-deployment.yaml
                      kubectl -n status-page apply -f k8s/statuspage-placeholder-service.yaml
                      
                      echo "=== Waiting for rollout to complete ==="
                      kubectl -n status-page rollout status deployment/statuspage-placeholder --timeout=120s
                    '''
                }
            }
        }
    }
}

