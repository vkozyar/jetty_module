remote_file "#{Chef::Config[:file_cache_path]}/epel-release-latest-6.noarch.rpm" do 
  source "https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm"; 
  not_if "rpm -qa | grep -q '^epel-release-latest'"
  notifies :install, "rpm_package[epel-release-latest]", :immediately
end

rpm_package "epel-release-latest" do
  source "#{Chef::Config[:file_cache_path]}/epel-release-latest-6.noarch.rpm" 
  only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/epel-release-latest-6.noarch.rpm")} 
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/php55-latest.rpm" do
  source "https://mirror.webtatic.com/yum/el6/latest.rpm";
  not_if "rpm -qa | grep -q '^php55-latest'"
  notifies :install, "rpm_package[php55-latest]", :immediately
end

rpm_package "php55-latest" do
  source "#{Chef::Config[:file_cache_path]}/php55-latest.rpm"
  only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/php55-latest.rpm")}
  action :nothing
end

#rpm_package "epel-release-latest-6.noarch.rpm" do
#  action :install
#end

#rpm_package "https://mirror.webtatic.com/yum/el6/latest.rpm" do
#  action :install
#end

#execute "php5_add_rpm" do
#  command "rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm"
#  action :run
#end

#execute "php5_add_rpm_latest" do
#  command "rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm"
#  action :run
#end

package "php55w" do
    action :install
end
package "php-pear" do
    action :install
end
package "php55w-mysql" do
    action :install
end

cookbook_file "/etc/php.ini" do
  source "php.ini"
  mode "0644"
  notifies :restart, "service[httpd]"
end
