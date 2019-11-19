pipeline {
    agent {
        kubernetes {
              // Change the name of jenkins-maven label to be able to use yaml configuration snippet
              label "maven-dind"
              // Inherit from Jx Maven pod template
              inheritFrom "maven"
              // Add pod configuration to Jenkins builder pod template
              yamlFile "maven-dind.yaml"
        }
    }
    environment {
      ORG               = 'activiti'
      APP_NAME = 'jenkins-x-image' 
      APP_VERSION = jx_release_version()  
   }
    stages {
      stage('Build Release') {
        when {
          branch 'master'
        }
          
        steps {
          container('maven') {
            // ensure we're not on a detached head
            sh "git checkout master"
            sh "git config --global credential.helper store"

            sh "jx step git credentials"
            sh "echo \$(jx-release-version) > VERSION"
            sh "git add --all"
            sh "git commit -m "release $(APP_VERSION)" --allow-empty"
            sh "git tag -fa v$(APP_VERSION) -m "Release version $(APP_VERSION)"
            sh "git push origin v$(APP_VERSION)"

            sh 'export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml'
            sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"
          }
        }
          }
        }
    post {
        always {
            cleanWs()
        }
    }
}
def jx_release_version() {
  container('maven') {
      return sh( script: "echo \$(jx-release-version)", returnStdout: true).trim()
  }
}
