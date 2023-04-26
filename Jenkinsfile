pipeline {
  agent any
  stages {
    stage('Build') {
      when {
        expression {
          return env.GIT_BRANCH == "origin/develop"
        }
      }
      steps {
        sh 'mvn clean install'
      }
    }
    stage('Test') {
      when {
        expression {
          return env.GIT_BRANCH == "origin/develop"
        }
      }
      steps {
        sh 'mvn test'
      }
    }
    stage('Versioning') {
      when {
        expression {
          return env.GIT_BRANCH == "origin/master"
        }
      }
      steps {
        script {
          def ghApiUrl = "https://api.github.com/repos/{OWNER}/{REPO}/actions/workflows/{WORKFLOW_FILE}/dispatches"
          def authToken = "GITHUB_TOKEN"
          def payload = "{\"ref\":\"${env.BRANCH_NAME}\"}"
          
          def response = sh(returnStdout: true, script: "curl -X POST -H 'Authorization: token ${authToken}' -H 'Accept: application/vnd.github.v3+json' -d '${payload}' ${ghApiUrl}")
          println(response)

          // Check if authentication failed
          if (response.contains("401 Unauthorized")) {
            error("Failed to authenticate with GitHub Actions API. Check your credentials.")
          }
        }
      }
    }
    stage('Build Docker RC Image') {
      when {
        expression {
          return env.GIT_BRANCH == "origin/master"
        }
      }
      steps {
        sh 'docker build -t my-app:$VERSION .'
        // sh 'docker tag my-app:$VERSION my-app:latest'
        // sh 'docker push my-app:$VERSION'
        // sh 'docker push my-app:latest'
      }
    }
  }
}
