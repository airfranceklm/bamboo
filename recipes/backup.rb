#
# Cookbook Name:: bamboo
# Recipe:: backup
#
# Copyright 2014
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "backup"

backup_install node.name
backup_generate_config node.name

backup_generate_model "database" do
  description "Our shard"
  backup_type "database"
  database_type "MySQL"
  store_with({"engine" => "S3", "settings" => { "s3.access_key_id" => "#{node[:bamboo][:backup][:s3_access_key_id]}", "s3.secret_access_key" => "#{node[:bamboo][:backup][:s3_secret_access_key]}", "s3.bucket" => "#{node[:bamboo][:backup][:s3_bucket]}", "s3.path" => "bamboo-database", "s3.keep" => 5, "s3.fog_options" => {  :host => "#{node[:bamboo][:backup][:s3_host]}", :scheme => "#{node[:bamboo][:backup][:s3_scheme]}", :port => "#{node[:bamboo][:backup][:s3_port]}" } } } )
  options({"db.host" => "\"#{node[:bamboo][:database][:host]}\"", "db.port" => "\"#{node[:bamboo][:database][:port]}\"", "db.username" => "\"#{node[:bamboo][:database][:user]}\"", "db.password" => "\"#{node[:bamboo][:database][:password]}\"", "db.name" => "\"#{node[:bamboo][:database][:name]}\""})
  action :backup
end

backup_generate_model "data" do
  description "bamboo data"
  backup_type "archive"
  options({"add" => ["#{node['bamboo']['data_dir']}"], "tar_options" => "-p"  })
  store_with({"engine" => "S3", "settings" => { "s3.access_key_id" => "#{node[:bamboo][:backup][:s3_access_key_id]}", "s3.secret_access_key" => "#{node[:bamboo][:backup][:s3_secret_access_key]}", "s3.bucket" => "#{node[:bamboo][:backup][:s3_bucket]}", "s3.path" => "bamboo-data", "s3.keep" => 5, "s3.fog_options" => {  :host => "#{node[:bamboo][:backup][:s3_host]}", :scheme => "#{node[:bamboo][:backup][:s3_scheme]}", :port => "#{node[:bamboo][:backup][:s3_port]}" } } } )
  action :backup
end
