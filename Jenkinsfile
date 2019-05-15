pipeline {
  agent any
  stages {
    stage('Find Branch Name') {
      steps {
        echo "Found branch name of: ${env.BRANCH_NAME}"
      }
    }
    stage('Refresh Dev Domain') {
      when {
        branch 'dev'
      }
        steps {
            echo "Refreshing DEV Automate Domain"
            sh '''
            /usr/bin/curl -k -X POST -d'{"action":"refresh_from_source"}' -u admin:smartvm "https://cfme-cicd-dev.example.com/api/automate_domains/cloudforms-cicd"
            '''
            }
    }
    stage('Provision VM') {
      when {
        branch 'dev'
      }
      steps {
          echo "Provisioning Test VM"
          sh 'ruby /ruby_scripts/test.rb'
          echo "VM Succesfully Provisioned"
          }
        }
    }
}
