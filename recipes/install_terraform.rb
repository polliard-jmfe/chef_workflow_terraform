#
# Cookbook Name:: chef_workflow_terraform
# Recipe:: install_terraform
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Location where the Terraform binary will be installed to
# We install this in the Workflow workspace as the Chef Client
# run does not run as root
terraform_install_dir = workflow_workspace

# Using the ark cookbook to install Terraform
 ark "terraform" do
   path terraform_install_dir
   url node['chef_workflow_terraform']['install_url']
   checksum node['chef_workflow_terraform']['package_checksum']
   strip_components 0
   owner 'dbuild'
   group 'dbuild'
   action :put
 end