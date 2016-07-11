# Generate self-signed certificate
execute "generate_self_key" do
  command "openssl genrsa -out /etc/ssl/certs/self-ssl.key 2048"
  action :run
end

execute "generate_self_csr" do
  command "openssl req -new -key /etc/ssl/certs/self-ssl.key -out /etc/ssl/certs/self-ssl.csr"
  action :run
end

execute "generate_self_crt" do
  command "openssl x509 -req -days 365 -in /etc/ssl/certs/self-ssl.csr -signkey /etc/ssl/certs/self-ssl.key -out /etc/ssl/certs/self-ssl.crt"
  action :run
end

