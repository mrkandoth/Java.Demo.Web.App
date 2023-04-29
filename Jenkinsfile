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
          withCredentials([string(credentialsId: 'github-token', variable: 'authToken')]) {
              script {
                  def isSemanticReleaseBotCommit = sh(returnStdout: true, script: 'git log --format=%an -n 1').trim() == 'semantic-release-bot'
                  if (isSemanticReleaseBotCommit) {
                    echo "Skipping the stage due to commit by semantic-release-bot"
                    return
                  }
                  def ghApiUrl = "https://api.github.com/repos/${env.OWNER}/${env.REPO}/actions/workflows/${env.WORKFLOW_FILE}/dispatches"
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
  }
    stage('Build Docker RC Image') {
      when {
          expression {
              return env.GIT_BRANCH == "origin/master"
          }
      }      
      steps {
          script {
            def commitMessage = sh(returnStdout: true, script: 'git log --format=%B -n 1').trim()
            def VERSION = sh(script: 'git describe --abbrev=0 --tags', returnStdout: true).trim()
            if (env.GIT_BRANCH == "origin/master" && commitMessage =~ /chore\(release\): \d+\.\d+\.\d+/) {
              sh "docker build --no-cache -t ${env.ECR_REPOSITORY}:${VERSION} ."
            } else {
              echo "Skipping the stage due to incorrect commit message format or branch"
            }
        }
      }
    }
    stage('Push to AWS ECR') {
      when {
          expression {
              return env.GIT_BRANCH == "origin/master"
          }
      }
      environment {
          // Configure AWS credentials
          AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
          AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
      }      
      steps {
          script {
            withCredentials([string(credentialsId: 'aws-credentials', variable: 'AWS_CREDENTIALS')]) {
              def commitMessage = sh(returnStdout: true, script: 'git log --format=%B -n 1').trim()
              def VERSION = sh(script: 'git describe --abbrev=0 --tags', returnStdout: true).trim()
              if (env.GIT_BRANCH == "origin/master" && commitMessage =~ /chore\(release\): \d+\.\d+\.\d+/) {
                // Configure AWS CLI
                sh 'echo $AWS_CREDENTIALS > aws-credentials'
                sh 'aws configure --profile ecr-credentials set aws_access_key_id "$(cat aws-credentials | grep -oP \'(?<=accessKeyId": ")[^\"]+\')"'
                sh 'aws configure --profile ecr-credentials set aws_secret_access_key "$(cat aws-credentials | grep -oP \'(?<=secretAccessKey": ")[^\"]+\')"'
                sh 'aws configure --profile ecr-credentials set aws_session_token "$(cat aws-credentials | grep -oP \'(?<=sessionToken": ")[^\"]+\')"'
                // Login to AWS ECR
                sh "aws ecr get-login-password --region $env.AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $env.ECR_REPOSITORY"
                // Push Docker image to ECR
                sh "docker push ${env.ECR_REPOSITORY}:${VERSION}"
              } else {
                echo "Skipping the stage due to incorrect commit message format or branch"
              } 
            }
        }
      }
    }
  }
  stage('Deploy to INT with Harness CD') {
    steps {
        script {
            def commitMessage = sh(returnStdout: true, script: 'git log --format=%B -n 1').trim()
            def VERSION = sh(script: 'git describe --abbrev=0 --tags', returnStdout: true).trim()
            if (env.GIT_BRANCH == "origin/master" && commitMessage =~ /chore\(release\): \d+\.\d+\.\d+/) {
                // Deploy to Kubernetes using Harness CD
                withCredentials([string(credentialsId: 'harness-credentials', variable: 'HARNESS_CREDENTIALS')]) {
                    sh 'echo $HARNESS_CREDENTIALS > harness-credentials'
                    // Set up Harness CD CLI and authenticate
                    sh "harness configure --url $env.HARNESS_URL --email $env.HARNESS_EMAIL --secret $(cat harness-credentials)"

                    // Trigger the deployment
                    sh "harness k8s-deployment apply --service <service-name> --image ${env.ECR_REPOSITORY}:${VERSION}"
                }
            } else {
                echo "Skipping the stage due to incorrect commit message format or branch"
            }
        }
    }
  }
}