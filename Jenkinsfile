pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout from GitHub using Jenkins credentials
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/cicd-setup']],
                          userRemoteConfigs: [[
                              url: 'https://github.com/missviee/status-page-final-workshop.git',
                              credentialsId: 'github-token'
                          ]]
                ])
            }
        }

        stage('Build') {
            steps {
                sh './build.sh'
            }
        }

        stage('Test') {
            steps {
                sh './test.sh'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to staging...'
            }
        }
    }
}

