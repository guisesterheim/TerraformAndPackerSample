pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_KEY = credentials('AWS_SECRET_KEY')
    }

    stages {
        stage('Build') {
            steps {
                // Some updates and cleaning old files
                sh 'rm -rf packer'
                sh 'rm -rf ilegraArchTest'
                sh 'rm -rf packer_1.5.5_linux_amd64.zip'
                
                // Get the packer json build file
                sh 'git clone https://github.com/guisesterheim/ilegraArchTest/'

                // Install Packer
                // TODO: Change for just checking version instead of downloading packer every time
                sh 'wget -c https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip'
                sh 'unzip -o packer_1.5.5_linux_amd64.zip'

                retry(3){
                    // Packer Build
                    sh './packer build -machine-readable -var aws_access_key=$AWS_ACCESS_KEY_PSW -var aws_secret_key=$AWS_SECRET_KEY_PSW ilegraArchTest/aws-template.json | tee build.log'
                }
            }
        }
    }
}