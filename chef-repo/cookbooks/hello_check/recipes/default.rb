#
# Cookbook Name:: hello_check
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
template '/etc/motd' do
  source 'server-info.erb'
  mode '0644'
end
