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
          sh './cfme-scripts/cfme-lifecycle-test.rb cfme-cicd-dev.example.com admin:smartvm'
          echo "VM Succesfully Provisioned"
          }
        }
    stage('Refresh Production Domain') {
      when {
        branch 'master'
      }
        steps {
            echo "Refreshing Production Automate Domain"
            sh '''
            /usr/bin/curl -k -X POST -d'{"action":"refresh_from_source"}' -u admin:smartvm "https://cfme-cicd-prod.example.com/api/automate_domains/cloudforms-cicd"
            '''
            }
    }
    stage('Provision Production VM') {
      when {
        branch 'master'
      }
      steps {
          echo "Provisioning Prodcution Test VM"
          sh './cfme-scripts/cfme-lifecycle-test.rb cfme-cicd-prod.example.com admin:smartvm'
          echo "VM Succesfully Provisioned"
          }
        }
    }
}
