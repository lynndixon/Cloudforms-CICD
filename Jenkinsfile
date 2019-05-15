pipeline {
  agent any
  stages {
    stage('Build') {
        expression {
        echo "BRANCH_NAME is ${env.BRANCH_NAME}"
        return env.BRANCH_NAME == "dev"
        }
      steps {
        echo "Found branch name of ${env.BRANCH_NAME}"
      }
    }
    stage('Refresh Dev Domain') {
        steps {
            echo "Refreshing DEV Automate Domain"
            sh '''
            /usr/bin/curl -k -X POST -d'{"action":"refresh_from_source"}' -u admin:smartvm "https://cfme-cicd-dev.example.com/api/automate_domains/cloudforms-cicd"
            '''
            }
    }
    stage('Provision VM') {
      steps {
          echo "Provisioning Test VM"
          sh 'ruby /ruby_scripts/test.rb'
          echo "Provisioning VM"
          }
        }
    }
}
