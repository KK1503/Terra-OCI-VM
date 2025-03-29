pipeline {
    agent any

    stages {
        stage('Initializing Terraform') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Planning in Terraform') {
            steps {
                sh 'sudo terraform plan'
            }
        }
        stage('Aplying in Terraform') {
            steps {
                sh 'sudo terraform apply -auto-approve'
            }
        }
    }
}
