#
# Cookbook Name:: chef_workflow_terraform
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

if node['chef_workflow_terraform']['install']
    include_recipe '::install_terraform'
end

# Load the delivery-secrets data bag item for this project
# See README for details on the contents of this data bag item
project_secrets = get_project_secrets

# Path to the Terraform binary once installed
terraform_cmd = "#{workflow_workspace}/terraform/terraform"

# Location where the Terraform module will be generated
terraform_module_dir = "#{node['delivery']['workspace']['cache']}/terraform/module"

# Location where the Terraform plan will be staged
terraform_plan_dir = "#{node['delivery']['workspace']['cache']}/terraform/plan"

# Clean up Terraform workspace
[terraform_module_dir, terraform_plan_dir].each do |dir|
    directory dir do
      recursive true
      action :delete
    end
end

# Create Terraform module and plan directories
[terraform_module_dir, terraform_plan_dir].each do |dir|
    directory dir do
      owner 'dbuild'
      group 'dbuild'
      mode '0755'
      recursive true
      action :create
    end
end

# Generate the Terraform module from a template
template "#{terraform_module_dir}/main.tf" do
  source 'main.tf.erb'
  owner 'dbuild'
  group 'dbuild'
  mode '0644'
  action :create
end

# Initialize the Terraform plan
terraform_state_dir = "#{node['delivery']['change']['project']}/#{workflow_chef_environment_for_stage}/terraform.tfstate"

execute 'Run terraform init' do
  command "terraform init -backend=s3 \
    -backend-config='bucket=#{node['chef_workflow_terraform']['s3_bucket_name']}' \
    -backend-config='key=#{terraform_state_dir}' \
    -backend-config='acl=bucket-owner-full-control' \
    -backend-config='region=#{node['chef_workflow_terraform']['s3_bucket_region']}' \
    #{terraform_module_dir}"
  cwd terraform_plan_dir
  environment ({
    'AWS_ACCESS_KEY_ID' => project_secrets['aws_access_key_id'],
    'AWS_SECRET_ACCESS_KEY' => project_secrets['aws_secret_access_key']
    })
  live_stream true
  action :run
end

# Generate the Terraform variable response file
template "#{terraform_plan_dir}/main.tfvars" do
  source 'main.tfvars.erb'
  owner 'dbuild'
  group 'dbuild'
  mode '0644'
  variables ({
    :chef_environment => workflow_chef_environment_for_stage,
    :chef_cookbook => node['delivery']['change']['project']
  })
  action :create
end

# Copy the AWS EC2 ssh private key from the delivery-secrets data bag
# This key will be used to SSH into the new EC2 instance to bootstrap it
file "#{terraform_plan_dir}/aws_ssh_key.pem" do
  content project_secrets['aws_ssh_key']
  owner 'dbuild'
  group 'dbuild'
  mode '0600'
  sensitive true
  action :create
end

# Copy the Chef server user key from the delivery-secrets data bag
# This key will be used to register the EC2 instance with the Chef Server
file "#{terraform_plan_dir}/chef_user_key.pem" do
  content project_secrets['chef_user_key']
  owner 'dbuild'
  group 'dbuild'
  mode '0600'
  sensitive true
  action :create
end

# Destroy existing acceptance environment. We want to test against a clean instance
if node['delivery']['change']['stage'] == 'acceptance'
    execute 'Destroy existing acceptance environment' do
        command "#{terraform_cmd} destroy -var-file main.tfvars -force"
        cwd terraform_plan_dir
        environment ({
            'AWS_ACCESS_KEY_ID' => project_secrets['aws_access_key_id'],
            'AWS_SECRET_ACCESS_KEY' => project_secrets['aws_secret_access_key']
            })
        live_stream true
        action :run
    end
end

# Apply the Terraform plan
execute 'Apply Terraform Plan' do
  command "#{terraform_cmd} apply --var-file main.tfvars"
  cwd terraform_plan_dir
  environment ({
    'AWS_ACCESS_KEY_ID' => project_secrets['aws_access_key_id'],
    'AWS_SECRET_ACCESS_KEY' => project_secrets['aws_secret_access_key']
    })
  live_stream true
  action :run
end