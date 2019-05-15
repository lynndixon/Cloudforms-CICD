pipeline {
  agent any
  stages {
    stage('Building DEV') {
      when {
        branch 'dev'
      }
      steps {
        echo "Building DEV Branch"
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
    stage('Provision VM into DEV Cloudforms') {
      when {
        branch 'dev'
      }
      steps {
          echo "Provisioning Test VM into DEV Cloudforms"
          sh 'ruby /ruby_scripts/test.rb'
          echo "Provisioning VM"
          }
        }
    }
}
