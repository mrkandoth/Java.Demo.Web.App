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
        sh 'git fetch --tags'
        sh 'VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.version -q -DforceStdout)'
        sh 'RELEASE_TYPE=$(git log -1 --pretty=%B | grep -E "^fix|^feat|^docs|^style|^refactor|^perf|^test|^build|^ci|^chore")'
        sh 'if [ -z "$RELEASE_TYPE" ]; then RELEASE_TYPE=patch; fi'
        sh 'VERSION=$(mvn org.codehaus.mojo:versions-maven-plugin:2.7:set -DnewVersion=$(semver -p $RELEASE_TYPE $VERSION) -DgenerateBackupPoms=false -q -DforceStdout)'
        sh 'git tag -a $VERSION -m "Version $VERSION"'
        sh 'git push --tags'
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