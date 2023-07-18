# Define provider
provider “aws” {
  region = “eu-west-1"  # Replace with your desired region
}

# Create Developer EC2 instance
resource “aws_instance” “developer_instance” {
  count         = 1
  ami           = “ami-013d87f7217614e10”  # Replace with the desired AMI ID
  instance_type = “t2.micro”      # Replace with the desired instance type
  key_name = “SSG-KeyPair”         # Replace with the name of your key pair
  # Provisioner for Git installation on Developer-Server
  provisioner “remote-exec” {
    inline = [
      “sudo yum install -y unzip” # If your application is zipped
      “sudo yum install -y git”,  # Install Git
    ]
  }
  # Tags
  tags = {
    Name = “Developer-Server”
  }
}

# Create Jenkins EC2 instance
resource “aws_instance” “jenkins_instance” {
  count         = 1
  ami           = “ami-013d87f7217614e10"  # Replace with the desired AMI ID
  instance_type = “t2.micro”      # Replace with the desired instance type
  key_name = “SSG-KeyPair”         # Replace with the name of your key pair
  # Provisioner for Jenkins installation on SG-Jenkins-Server
  provisioner “remote-exec” {
    inline  = [
      “sudo yum update -y”,
      “sudo yum install -y wget”,
      “sudo yum install -y java-17-openjdk”,
      “sudo yum install -y python3 python3-pip”,
      “sudo yum install -y python3-devel”,
      “sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo”,
      “sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key”,
      “sudo yum install -y jenkins”,
      “sudo systemctl daemon-reload”,
      “sudo systemctl start jenkins”
    ]
  }
  # Tags
  tags = {
    Name = “Jenkins-Server”
  }
}
# Create Ansible EC2 instance
resource “aws_instance” “ansible_instance” {
  count         = 1
  ami           = “ami-013d87f7217614e10”  # Replace with the desired AMI ID
  instance_type = “t2.micro”      # Replace with the desired instance type
  key_name = “SSG-KeyPair”         # Replace with the name of your key pair
  # Provisioner for Ansible installation on SG-Ansible-Server
  provisioner “remote-exec” {
    inline  = [
      “sudo yum update -y”,
      “sudo yum install -y wget”,
      “sudo yum install -y epel-release”,
      “sudo yum install -y git”,
      “sudo yum install -y python3 python3-pip”,
      “sudo pip3 install ansible”,
      “ansible-galaxy collection install ansible.posix”
    ]
  }
  # Tags
  tags = {
    Name = “Ansible-Server”
  }
}
# Create Web/Apache Tomcat EC2 instance
resource “aws_instance” “web_instance” {
  count         = 1
  ami           = “ami-013d87f7217614e10”  # Replace with the desired AMI ID
  instance_type = “t2.micro”      # Replace with the desired instance type
key_name = “SSG-KeyPair”         # Replace with the name of your key pair
  # Provisioner for Apache Tomcat installation on SG-Web-Server
  provisioner “remote-exec” {
    inline = [
      “sudo yum update -y”,
      “sudo yum install -y java-17-openjdk”,
      “sudo yum install -y wget”,
      “sudo yum install -y python3 python3-pip”,
      “wget https://downloads.apache.org/tomcat/tomcat-10/v10.1.11/bin/apache-tomcat-10.1.11.tar.gz”,
      “tar -xf apache-tomcat-10.1.11.tar.gz”,
      “sudo mv apache-tomcat-10.1.11 /opt/tomcat”,
      “sudo chown -R ec2-user: /opt/tomcat”,
      “sudo chmod +x /opt/tomcat/bin/*.sh”,
      “sudo systemctl daemon-reload”,
      “”
    ]
  }
  # Tags
  tags = {
    Name = “Web-Server”
  }
}