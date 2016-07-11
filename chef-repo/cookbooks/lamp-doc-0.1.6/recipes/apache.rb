package "httpd" do
  action :install
end

package "mod_ssl" do
  action :install
end

# Generate self-signed certificate
#execute "generate_self_key" do
#  command "openssl genrsa -out /etc/ssl/certs/self-ssl.key 2048"
#  action :run
#end

#execute "generate_self_csr" do
#  command "openssl req -new -key /etc/ssl/certs/self-ssl.key -out /etc/ssl/certs/self-ssl.csr"
#  action :run
#end

#execute "generate_self_crt" do
#  command "openssl x509 -req -days 365 -in /etc/ssl/certs/self-ssl.csr -signkey /etc/ssl/certs/self-ssl.key -out /etc/ssl/certs/self-ssl.crt"
#  action :run
#end

#link '/etc/init.d/httpd' do
#  to '/etc/rc.d/init.d/httpd'
#end

service "httpd" do
  action [:start, :enable]
end

#directory '/etc/httpd/sites-available' do
#  owner 'root'
#  group 'root'
#  mode '0755'
#  action :create
#end

#Virtual Hosts Files

#template "/etc/httpd/conf.d/alfa.nod.conf" do
#    source "alfa.nod.conf.erb"
#    mode "0644"
#end

#template "/etc/httpd/conf.d/alfa.ecs.conf" do
#    source "alfa.ecs.conf.erb"
#    mode "0644"
#end

template "/etc/httpd/conf.d/jetty.nod.conf" do
    source "jetty.nod.conf.erb"
    mode "0644"
end

node["lamp-doc"]["sites"].each do |sitename, data|
  document_root = "/var/www/html/#{sitename}"

  directory document_root do
    mode "0755"
    recursive true
  end

#  execute "enable-sites" do
#    command "a2ensite #{sitename}"
#    action :nothing
#  end

#  directory '/etc/httpd/sites-available' do
#    owner 'root'
#    group 'root'
#    mode '0755'
#    action :create
#  end
  
#  directory '/etc/httpd/sites-enabled' do
#    owner 'root'
#    group 'root'
#    mode '0755'
#    action :create
#  end

#  link '/etc/httpd/sites-enabled' do
#    to '/etc/httpd/sites-available'
#  end

  template "/etc/httpd/conf.d/#{sitename}.conf" do
    source "virtual-hosts.erb"
    mode "0644"
    variables(
      :document_root => document_root,
      :port => data["port"],
      :serveradmin => data["serveradmin"],
      :servername => data["servername"]
    )
#  notifies :run, "execute[enable-sites]"
  notifies :restart, "service[httpd]"
  end

  directory "/var/www/html/#{sitename}/public_html" do
    action :create
  end

  template "/var/www/html/#{sitename}/public_html/phpinfo.php" do
    source "phpinfo.php.erb"
  end

  directory "/var/www/html/#{sitename}/logs" do
    action :create
  end

end

#directory '/etc/httpd/mods-available' do
#  owner 'root'
#  group 'root'
#  mode '0755'
#  action :create
#end

execute "keepalive" do
  command "sed -i 's/KeepAlive On/KeepAlive Off/g' /etc/httpd/conf/httpd.conf"
  action :run
end

#execute "enable-event" do
#  command "a2enmod mpm_event"
#  action :nothing
#end

#cookbook_file "/etc/httpd/mods-available/mpm_event.conf" do
#  source "mpm_event.conf"
#  mode "0644"
#  notifies :run, "execute[enable-event]"
#end

bash "apache_configure" do
  code <<-EOL
    sed -i 's/\# NameVirtualHost/NameVirtualHost/g' /etc/httpd/conf/httpd.conf
    sed -i 's/\#NameVirtualHost/NameVirtualHost/g' /etc/httpd/conf/httpd.conf
  EOL
end

