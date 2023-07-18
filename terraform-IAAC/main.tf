# Define provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create Developer EC2 instance
resource "aws_instance" "developer_instance" {
  count         = 1
  ami           = "ami-026ebd4cfe2c043b2"  # Replace with the desired AMI ID
  instance_type = "t2.micro"      # Replace with the desired instance type
  key_name      = "mytest_OL"     # Replace with the name of your key pair

  # User data for Git installation on Developer-Server
  user_data = <<-EOT
    #!/bin/bash
    sudo yum install -y unzip
    sudo yum install -y git
  EOT

  # Tags
  tags = {
    Name = "Developer-Server"
  }
}

# Create Jenkins EC2 instance
resource "aws_instance" "jenkins_instance" {
  count         = 1
  ami           = "ami-026ebd4cfe2c043b2"  # Replace with the desired AMI ID
  instance_type = "t2.micro"      # Replace with the desired instance type
  key_name      = "mytest_OL"     # Replace with the name of your key pair

  # User data for Jenkins installation on Jenkins-Server
  user_data = <<-EOT
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y wget
    sudo yum install -y java-17-openjdk
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum install -y jenkins
    sudo systemctl daemon-reload
    sudo systemctl start jenkins
    
    sleep 300
    
    sudo cd /home/ec2-user/.ssh/
    sudo ssh-keygen -t rsa -b 4096 -C "jenkins-control-machine" -q -N "" -f /home/ec2-user/.ssh/id_rsa
    sudo chmod 700 ~/.ssh
  EOT

  # Tags
  tags = {
    Name = "Jenkins-Server"
  }
}

# Create Ansible EC2 instance
resource "aws_instance" "ansible_instance" {
  count         = 1
  ami           = "ami-026ebd4cfe2c043b2"  # Replace with the desired AMI ID
  instance_type = "t2.micro"      # Replace with the desired instance type
  key_name      = "mytest_OL"     # Replace with the name of your key pair

  # User data for Ansible installation on Ansible-Server
  user_data = <<-EOT
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y wget
    sudo yum install -y epel-release
    sudo yum install -y git
    sudo yum install -y python3 python3-pip
    sudo pip3 install ansible
    ansible-galaxy collection install ansible.posix
    
    sudo mkdir /etc/ansible
    sudo chown -R $USER:$USER /etc/ansible
    sudo chmod -R 755 /etc/ansible
    sudo touch /etc/ansible/hosts
    
    sleep 300
    
    sudo cd /home/ec2-user/.ssh/
    sudo ssh-keygen -t rsa -b 4096 -C "ansible-control-machine" -q -N "" -f /home/ec2-user/.ssh/id_rsa
    sudo chmod 700 ~/.ssh
  EOT

  # Tags
  tags = {
    Name = "Ansible-Server"
  }
}

# Create Web/Apache Tomcat EC2 instance
resource "aws_instance" "web_instance" {
  count         = 1
  ami           = "ami-026ebd4cfe2c043b2"  # Replace with the desired AMI ID
  instance_type = "t2.micro"      # Replace with the desired instance type
  key_name      = "mytest_OL"     # Replace with the name of your key pair

  # User data for Apache Tomcat installation on Web-Server
  user_data = <<-EOT
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y java-17-openjdk
    sudo yum install -y wget
    sudo yum install -y python3 python3-pip
    wget https://downloads.apache.org/tomcat/tomcat-10/v10.1.11/bin/apache-tomcat-10.1.11.tar.gz
    tar -xf apache-tomcat-10.1.11.tar.gz
    sudo mv apache-tomcat-10.1.11 /opt/tomcat
    sudo chown -R ec2-user: /opt/tomcat
    sudo chmod +x /opt/tomcat/bin/*.sh
    sudo systemctl daemon-reload
    
    sudo chmod 700 ~/.ssh
  EOT

  # Tags
  tags = {
    Name = "Web-Server"
  }
}
