pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // Clean workspace and checkout the code from the GitHub repository
                cleanWs()
                git branch: 'main', url: 'https://github.com/ameyapb/django-jenkins-ansible-terraform-integration.git'
            }
        }
        stage('Deploy to Ansible Server') {
            steps {
                // Copy the built application code to the Ansible Server
                withCredentials([sshUserPrivateKey(credentialsId: '90e346b5-36e9-4e3f-b300-8d1bfbfa6b2d', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                    sh '''
                    rsync -e "ssh -o StrictHostKeyChecking=no -i $SSH_PRIVATE_KEY" -av --exclude venv/ ./ ec2-user@ec2-44-203-115-252.compute-1.amazonaws.com:/home/ec2-user/ansible-data/
                    '''
                }
            }
        }
        
        stage('Deploy using Ansible') {
            steps {
                // Run Ansible playbook on the Ansible Server
                withCredentials([sshUserPrivateKey(credentialsId: '90e346b5-36e9-4e3f-b300-8d1bfbfa6b2d', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_PRIVATE_KEY" ec2-user@ec2-44-203-115-252.compute-1.amazonaws.com 'ansible-playbook -i /etc/ansible/hosts /home/ec2-user/ansible-data/ansible-playbooks/deploy-web-app.yml'
                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'Deployment and Web App successful!'
            // Additional success actions (if any)
        }
        failure {
            echo 'Deployment or Web App failed!'
            // Additional failure actions (if any)
        }
    }
}
