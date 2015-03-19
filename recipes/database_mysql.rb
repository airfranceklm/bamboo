settings = Bamboo.settings(node)

database_connection = {
  :host => settings[:database][:host],
  :port => settings[:database][:port]
}

mysql_service 'default' do
  version node[:bamboo][:database][:version]
  bind_address node[:bamboo][:database][:host]
  port '3306'
  data_dir node[:mysql][:data_dir] if node[:mysql][:data_dir]
  initial_root_password node[:mysql][:server_root_password]
  action [:create, :start]
end

include_recipe 'database::mysql'
database_connection.merge!(:username => 'root', :password => node[:mysql][:server_root_password])

mysql_database settings[:database][:name] do
  connection database_connection
  collation 'utf8_bin'
  encoding 'utf8'
  action :create
end

# See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
mysql_database_user '' do
  connection database_connection
  host 'localhost'
  action :drop
end

mysql_database_user settings[:database][:user] do
  connection database_connection
  host '%'
  password settings[:database][:password]
  database_name settings[:database][:name]
  action [:create, :grant]
end
