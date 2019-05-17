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
    stage('Testing Dev VM Lifecycle') {
      when {
        branch 'dev'
      }
      steps {
          echo "Testing VM Lifecycle"
          sh './cfme-scripts/cfme-lifecycle-test.rb cfme-cicd-dev.example.com "admin:smartvm" "100000000000001"'
          echo "Lifecycle Testing Complete"
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
    stage('Testing Prod VM Lifecycle') {
      when {
        branch 'master'
      }
      steps {
          echo "Testing VM Lifecycle"
          sh './cfme-scripts/cfme-lifecycle-test.rb cfme-cicd-prod.example.com "admin:smartvm" "101000000000001"'
          echo "Lifecycle Testing Complete"
          }
        }
    }
}
