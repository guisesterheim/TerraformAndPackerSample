pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_KEY = credentials('AWS_SECRET_KEY')
    }

    stages {
        stage('Launch'){
            steps {
                // Clean old files
                sh 'rm -rf terraform'
                sh 'rm -rf TerraformAndPackerSample'
                sh 'rm -rf terraform_0.12.24_linux_amd64.zip'

                // TODO: automate getting the last version of terraform
                // Install Terraform
                sh 'wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip'
                sh 'unzip -o terraform_0.12.24_linux_amd64.zip'

                sh 'git clone https://github.com/guisesterheim/TerraformAndPackerSample/'

                // Launch a new machine with the AMI generated on the first step
                sh './terraform init TerraformAndPackerSample/terraform_startup/'
                sh './terraform plan -var aws_region=us-east-1 -var aws_access_key=$AWS_ACCESS_KEY_PSW -var aws_secret_key=$AWS_SECRET_KEY_PSW -out tfout.log TerraformAndPackerSample/terraform_startup/'
                sh './terraform apply tfout.log'
            }
        }
    }
}
