settings = Bamboo.settings(node)

database_connection = {
  :host => settings[:database][:host],
  :port => settings[:database][:port]
}

include_recipe 'build-essential'

case settings['database']['type']
when 'mysql'
  mysql_client 'default' do
    action :create
  end

  mysql2_chef_gem 'Default' do
    client_version node[:bamboo][:database][:version]
    action :install
  end

  unless node[:bamboo][:database][:external] == true
    mysql_service settings[:database][:name] do
      version node[:bamboo][:database][:version]
      bind_address node[:bamboo][:database][:host]
      port '3306'
      data_dir node[:mysql][:data_dir] if node[:mysql][:data_dir]
      initial_root_password node[:mysql][:server_root_password]
      action [:create, :start]
    end
  end

  database_connection[:username] = node[:bamboo][:database][:root_user_name]
  database_connection[:password] = node[:mysql][:server_root_password]
  database_connection[:socket] = "/var/run/mysql-#{settings[:database][:name]}/mysqld.sock"

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
when 'postgresql'
  include_recipe 'postgresql::server' unless node[:bamboo][:database][:external] == true
  include_recipe 'database::postgresql'

  database_connection[:username] = node[:bamboo][:database][:root_user_name]
  database_connection[:password] = node[:postgresql][:password][:postgres]

  postgresql_database settings[:database][:name] do
    connection database_connection
    connection_limit '-1'
    encoding 'utf8'
    action :create
  end

  postgresql_database_user settings[:database][:user] do
    connection database_connection
    password settings[:database][:password]
    database_name settings[:database][:name]
    action [:create, :grant]
  end
end
