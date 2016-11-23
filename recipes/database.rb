settings = merge_bamboo_settings

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
    mysql_service 'default' do
      version node[:bamboo][:database][:version]
      bind_address node[:bamboo][:database][:host]
      port '3306'
      data_dir node[:mysql][:data_dir] if node[:mysql][:data_dir]
      initial_root_password node[:mysql][:server_root_password]
      action [:create, :start]
    end
  end

  mysql_service 'bamboo' do
    version settings['database']['version'] if settings['database']['version']
    bind_address settings['database']['host']
    port settings['database']['port'].to_s
    data_dir node['mysql']['data_dir'] if node['mysql']['data_dir']
    initial_root_password node['mysql']['server_root_password']
    action [:create, :start]
  end

  mysql_database settings['database']['name'] do
    connection confluence_database_connection
    collation 'utf8_bin'
    encoding 'utf8'
    action :create
  end

  # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
  mysql_database_user '' do
    connection confluence_database_connection
    host 'localhost'
    action :drop
  end

  mysql_database_user settings['database']['user'] do
    connection confluence_database_connection
    host '%'
    password settings['database']['password']
    database_name settings['database']['name']
    action [:create, :grant]
  end

when 'postgresql'
  include_recipe 'postgresql::server' unless node[:bamboo][:database][:external] == true
  include_recipe 'database::postgresql'

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

when 'hsqldb'
  # No-op. HSQLDB doesn't require any configuration.
end
