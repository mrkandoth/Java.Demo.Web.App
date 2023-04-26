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
              def ghToken = "GITHUB_TOKEN"  // Assuming you have defined GITHUB_TOKEN credentials in Jenkins Agent Env
              def ghRepoOwner = 'mrkandoth'
              def ghRepoName = 'Java.Demo.Web.App'
              def ghWorkflowName = 'Release'
              
              def apiUrl = "https://api.github.com/repos/${ghRepoOwner}/${ghRepoName}/actions/workflows/${ghWorkflowName}/dispatches"
              
              def response = httpRequest(
                  httpMode: 'POST',
                  url: apiUrl,
                  authentication: ghToken,
                  contentType: 'APPLICATION_JSON',
                  wrapAsMultipart: false,
                  requestBody: '{"ref": "master"}'  // Replace with your desired branch/ref
              )
              
              if (response.status == 204) {
                  println "GitHub Actions job triggered successfully!"
              } else {
                  println "Failed to trigger GitHub Actions job. Status code: ${response.status}"
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


pipeline {
    agent any
    
    stages {
        stage('Trigger GitHub Actions Job') {
            steps {
                script {
                    def ghToken = credentials('github-token')  // Assuming you have defined GitHub token credentials in Jenkins
                    def ghRepoOwner = 'your-github-username'
                    def ghRepoName = 'your-github-repo'
                    def ghWorkflowName = 'your-workflow-name'
                    
                    def apiUrl = "https://api.github.com/repos/${ghRepoOwner}/${ghRepoName}/actions/workflows/${ghWorkflowName}/dispatches"
                    
                    def response = httpRequest(
                        httpMode: 'POST',
                        url: apiUrl,
                        authentication: ghToken,
                        contentType: 'APPLICATION_JSON',
                        wrapAsMultipart: false,
                        requestBody: '{"ref": "main"}'  // Replace with your desired branch/ref
                    )
                    
                    if (response.status == 204) {
                        println "GitHub Actions job triggered successfully!"
                    } else {
                        println "Failed to trigger GitHub Actions job. Status code: ${response.status}"
                    }
                }
            }
        }
    }
}
