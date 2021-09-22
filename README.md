# Automate-Infrastructure-using-Terraform

This project is about to automate infrastructure using Terraform and Ansible, For this we use terraform to deploy an EC2 instance in AWS and then we use Ansible as a configuration management tool using local ubuntu machine.

1. Automate Infrastructure Using Terraform: 
        
        ➢ Configuring Terraform in local machine.
        ➢ Creating a directory for aws configuration because each terraform must have its own working directory.
        ➢ Create a file to define aws infrastructure main.tf file.
        ➢ Initialize directory with terraform init.
        ➢ Initializing configuration directory downloads and install the providers define in the configuration, in our case it is aws.
        ➢ Creating an execution plan by terraform plan which consist of :
                I. Reading the current state.
                II. Comparing the current configuration to prior state.
                III. Proposing a set of change actions.
        ➢ Terraform apply executes the action proposed in a terraform plan.
        ➢ Terraform destroy is a convenient way to destroy all remote objects manage by terraform configuration (main.tf).

2. Managing Configuration and deploying applications:
        
        ➢ Installing Ansible in instance, in our case already installed through terraform main.tf file.
        ➢ Creating directory ansible_files for the configuration management, in our case already done by terraform main.tf file.
        ➢ Setting up our own inventory while ansible have its inventory in /etc/ansible/hosts.
        ➢ Creating a playbook in our case installer.yml file, which tells ansible which tools needs to be deploy, in our case we install Java, Jenkins and python.

3. Main.tf file:

        ➢ Terraform Block contains terraform settings, including the required providers which used to provision infrastructure.
        ➢ Provider block configures the specified provider in our case its aws, it is a plugin that terraform uses and manage our resources, in our case it consist of:
                I. Region 
                II. Access_key
                III. Secert_key
        ➢ Resource Block defines components of infrastructure, it might be physical or virtual such as ec2. In our case these are:
                I. VPC
                II. Internet Gateway
                III. Route Table
                IV. Subnet
                V. Security Group
                VI. Network Interface
                VII. Elastic IP
                VIII. AMI
