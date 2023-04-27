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
                def isSemanticReleaseBotCommit = sh(returnStdout: true, script: 'git log --format=%an -n 1').trim() == 'semantic-release-bot'
                if (isSemanticReleaseBotCommit) {
                  echo "Skipping the stage due to commit by semantic-release-bot"
                  return
                }
                def ghApiUrl = "https://api.github.com/repos/${env.OWNER}/${env.REPO}/actions/workflows/${env.WORKFLOW_FILE}/dispatches"
                def authToken = env.GITHUB_TOKEN
                def payload = "{\"ref\":\"${env.BRANCH_NAME}\"}"

                def response = sh(returnStdout: true, returnStatus: true, script: "curl -X POST -H 'Authorization: token ${authToken}' -H 'Accept: application/vnd.github.v3+json' -d '${payload}' ${ghApiUrl}")
                println(response)

                // Check if authentication failed
                if (response == 0) {
                    println "GitHub Actions job triggered successfully!"
                } else {
                    println "Failed to trigger GitHub Actions job. Status code: ${response}"
                }
            }
        }
    }
    stage('Build Docker RC Image') {
      steps {
          script {
            def commitMessage = sh(returnStdout: true, script: 'git log --format=%B -n 1').trim()
            if (env.GIT_BRANCH == "origin/master" && commitMessage =~ /chore\(release\): \d+\.\d+\.\d+/) {
              sh "docker build --no-cache -t java-demo-app:${sh(script: 'git describe --abbrev=0 --tags', returnStdout: true).trim()} ."
              // sh 'docker tag my-app:$VERSION my-app:latest'
              // sh 'docker push my-app:$VERSION'
              // sh 'docker push my-app:latest'
            } else {
              skipped("Skipping the stage due to incorrect commit message format or branch")
            }
        }
      }
    }
  }
}
