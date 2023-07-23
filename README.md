# Devops Project: django-jenkins-ansible-terraform-integration


This repository contains code and configurations for automating the deployment of a web application using Django, Jenkins, Ansible, and Terraform.

## Getting Started

### GitHub Setup

1. Create a GitHub repository for your application.

2. Clone the repository to your local machine using VScode.

3. Commit your changes and push them to GitHub.

### Terraform Setup

1. Install and configure Terraform on your local machine.

2. Create a `main.tf` file and paste the required configuration.

3. Run `terraform init` and `terraform apply -auto-approve -input=false | tee install.log`.

### Jenkins Configuration

1. Set up SSH authentication between Jenkins and Ansible servers.

2. Access Jenkins at `http://<Jenkins-Server-Public-IP>:8080`.

3. Install suggested plugins and create your login credentials.

4. Install the "Publish over SSH" plugin.

5. Set up a GitHub webhook in your repository settings to trigger Jenkins on push events.

### Ansible Configuration

1. Set up SSH authentication between Ansible and Jenkins servers.

2. Create a directory to store data received from Jenkins.

3. Edit the Ansible hosts file to add the web server's public IP.

### Jenkins Pipeline

1. Create a new Jenkins Job as a Pipeline.

2. Configure the pipeline script from SCM with the repository URL, credentials, and branch specifier.

3. Commit and push the Jenkinsfile to the main branch.

### Deployment

Now your DevOps pipeline is ready! Pushing changes to the repository will trigger the pipeline and automatically deploy the latest version of your web application.
