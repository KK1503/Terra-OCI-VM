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
                sh 'terraform plan'
            }
        }
        stage('Aplying in Terraform') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
