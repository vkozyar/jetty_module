#
# Cookbook Name:: lamp-doc
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "update-upgrade" do
  command "yum install mlocate wget tar vim -y"
  action :run
end

