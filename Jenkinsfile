pipeline {
    agent any
    
    stages {
        stage('Clone repository') {
            steps {
                script {
                    git 'https://github.com/vpob210/1_simple_cicd_web.git'
                }
            }
        }
        
        stage('Build and run Docker container') {
            steps {
                script {
                    sh 'docker build -t my-node-js-app .'
                    sh 'docker run -d -p 99:3000 my-node-js-app'
                }
            }
        }
    }
}
