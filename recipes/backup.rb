include_recipe "backup"

backup_install node.name
backup_generate_config node.name

backup_generate_model "mysql" do
  description "Our shard"
  backup_type "database"
  database_type "MySQL"
  store_with({"engine" => "S3", "settings" => { "s3.access_key_id" => "BN588NGSSFPKQHD1NX21", "s3.secret_access_key" => "8abEbk+jZyx3c9Td2etAMO031bkXmqQEGjET8WcE", "s3.bucket" => "backups", "s3.path" => "bamboo", "s3.keep" => 10, "s3.fog_options" => {  :host => 's3.eden.klm.com', :scheme => 'http', :port => 80 } } } )
  options({"db.host" => "\"localhost\"", "db.username" => "\"#{node[:bamboo][:jdbc_username]}\"", "db.password" => "\"#{node[:bamboo][:jdbc_password]}\"", "db.name" => "\"bamboo\""})
  action :backup
end
