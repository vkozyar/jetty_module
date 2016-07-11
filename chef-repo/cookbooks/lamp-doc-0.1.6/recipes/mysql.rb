mysqlpass = data_bag_item("mysql", "rtpass.json")

package "mysql-server" do
    action :install
end

mysql_client 'default' do
  action :create
end

mysql_service "mysqldefault" do
  initial_root_password mysqlpass["password"]
  action [:create, :start]
end
