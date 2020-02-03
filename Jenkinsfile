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
            sh 'export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml'
            sh "make tag"
          }
        }
          }
        }
    post {
        failure {
           slackSend(
             channel: "#activiti-community-builds",
             color: "danger",
             message: "jenkins-x-image branch=$BRANCH_NAME is failed http://jenkins.jx.35.242.205.159.nip.io/job/Activiti/job/jenkins-x-image"
           )
        } 
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
