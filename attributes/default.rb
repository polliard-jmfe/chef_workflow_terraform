# Terraform install package
default['chef_workflow_terraform']['install']           = true
default['chef_workflow_terraform']['install_url']       = 'https://releases.hashicorp.com/terraform/0.9.1/terraform_0.9.1_linux_amd64.zip'
default['chef_workflow_terraform']['package_checksum']  = 'b3b18a719258dcc02b7b972eedf417be0b497e4129063711bca82877dbe65553'

# S3 Bucket to store Terraform remote state files
default['chef_workflow_terraform']['s3_bucket_name']    = "jmfe-terraform-backend-us-east-1"
default['chef_workflow_terraform']['s3_bucket_region']  = "us-east-1"

# EC2 Instance Configuration
default['chef_workflow_terraform']['aws_resource_prefix']   = "automate"
default['chef_workflow_terraform']['aws_region']            = "us-east-1"
default['chef_workflow_terraform']['ec2_instance_type']     = "t2.small"
# default['chef_workflow_terraform']['ec2_ami_id']            = ""
default['chef_workflow_terraform']['ec2_login_user']        = "ec2-user"
default['chef_workflow_terraform']['ec2_keypair_name']      = "jmfe_chefkitchen"
default['chef_workflow_terraform']['ec2_connection_type']   = "ssh" #rdp|winrm
default['chef_workflow_terraform']['vpc_security_groups']   = ["sg-2933ee54"]
default['chef_workflow_terraform']['vpc_subnet']            = "subnet-e984eac2"

# Chef Client bootstrap configuration
default['chef_workflow_terraform']['chef_server_url']     = "https://chef.jmfamily.com/organizations/jm_family"
# default['chef_workflow_terraform']['chef_user_name']      = ""
default['chef_workflow_terraform']['chef_validator_pem_name'] = 'jm_family-validator'


# TODO: PR: Add Encryption
# TODO: PR: lock Table
# TODO: PR: AMI Search vs Fixed AMI.
# TODO: PR: Validator Client Name