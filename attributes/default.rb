# Terraform install package
default['chef_workflow_terraform']['install']           = true
default['chef_workflow_terraform']['install_url']       = 'https://releases.hashicorp.com/terraform/0.7.5/terraform_0.7.5_linux_amd64.zip'
default['chef_workflow_terraform']['package_checksum']  = '7def82015b3a9a1bab13b4548e4c8d4ac960322a815cff7d9ebf76ef74a4cb34'

# S3 Bucket to store Terraform remote state files
default['chef_workflow_terraform']['s3_bucket_name']    = ""
default['chef_workflow_terraform']['s3_bucket_region']  = ""

# EC2 Instance Configuration
default['chef_workflow_terraform']['aws_resource_prefix']   = ""
default['chef_workflow_terraform']['aws_region']            = ""
default['chef_workflow_terraform']['ec2_instance_type']     = ""
default['chef_workflow_terraform']['ec2_ami_id']            = ""
default['chef_workflow_terraform']['ec2_login_user']        = ""
default['chef_workflow_terraform']['ec2_keypair_name']      = ""
default['chef_workflow_terraform']['ec2_connection_type']   = "" 
default['chef_workflow_terraform']['vpc_security_groups']   = [""]
default['chef_workflow_terraform']['vpc_subnet']            = ""

# Chef Client bootstrap configuration
default['chef_workflow_terraform']['chef_server_url']     = ""
default['chef_workflow_terraform']['chef_user_name']      = ""