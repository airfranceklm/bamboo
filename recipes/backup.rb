include_recipe "backup"

backup_install node.name
backup_generate_config node.name

backup_generate_model "database" do
  description "Our shard"
  backup_type "database"
  database_type "MySQL"
  store_with({"engine" => "S3", "settings" => { "s3.access_key_id" => "#{node[:bamboo][:backup][:s3_access_key_id]}", "s3.secret_access_key" => "#{node[:bamboo][:backup][:s3_secret_access_key]}", "s3.bucket" => "#{node[:bamboo][:backup][:bucket]}", "s3.path" => "bamboo-database", "s3.keep" => 5, "s3.fog_options" => {  :host => 's3.eden.klm.com', :scheme => 'http', :port => 80 } } } )
  options({"db.host" => "\"localhost\"", "db.username" => "\"#{node[:bamboo][:database][:user]}\"", "db.password" => "\"#{node[:bamboo][:database][:password]}\"", "db.name" => "\"#{node[:bamboo][:database][:name]}\""})
  action :backup
end

backup_generate_model "data" do
  description "bamboo data"
  backup_type "archive"
  options({"add" => ["#{node['bamboo']['bamboo_home']}"], "tar_options" => "-p"  })
  store_with({"engine" => "S3", "settings" => { "s3.access_key_id" => "#{node[:bamboo][:backup][:s3_access_key_id]}", "s3.secret_access_key" => "#{node[:bamboo][:backup][:s3_secret_access_key]}", "s3.bucket" => "#{node[:bamboo][:backup][:bucket]}", "s3.path" => "bamboo-data", "s3.keep" => 5, "s3.fog_options" => {  :host => 's3.eden.klm.com', :scheme => 'http', :port => 80 } } } )
  action :backup
end
