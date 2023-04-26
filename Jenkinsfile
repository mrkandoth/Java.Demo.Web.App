pipeline {
    agent any
    
    stages {
        stage('Build') {
            when {
                branch 'develop'
            }
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            when {
                branch 'develop'
            }
            steps {
                sh 'mvn test'
            }
        }
        stage('Release') {
            when {
                branch 'master'
            }
            steps {
                sh 'docker build -t java-demo-app .'
            }
        }
    }
}