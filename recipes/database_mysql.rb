settings = Bamboo.settings(node)

database_connection = {
    :host => settings[:database][:host],
    :port => settings[:database][:port]
}

include_recipe 'mysql::server'
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
