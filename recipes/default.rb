#
# Cookbook Name:: chef-client
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

#TODO: CREATED UPGRADE SCRIPT

if (node[:bamboo][:external_data])
  directory "/mnt/data" do
    owner node[:bamboo][:user]
    group  node['bamboo']['group']
    mode "0775"
    action :create
  end
  mount "/mnt/data" do
    device "/dev/vdc1"
    fstype "ext4"
    action   [:mount, :enable]
  end
end

include_recipe "java"
include_recipe "ark"

user node['bamboo']['user'] do
  comment "Bamboo Service Account"
  #home    node['bamboo']['home_path']
  shell   "/bin/bash"
  supports :manage_home => true
  system  true
  action  :create
end

#TODO: need to notify service to stop before downloading new package
# download bamboo
ark node['bamboo']['name'] do
  url node['bamboo']['download_url']
  home_dir node['bamboo']['install_path']
  checksum node['bamboo']['checksum']
  version node['bamboo']['version']
  owner node['bamboo']['user']
  group node['bamboo']['group']
end


if (node[:bamboo][:mysql])
  directory "#{node['bamboo']['install_path']}/lib" do
    owner  node[:bamboo][:user]
    group  node[:bamboo][:group]
    mode "0775"
    action :create
  end

  mysql_connector_j "#{node['bamboo']['install_path']}/lib"
end

template "/etc/init.d/bamboo" do
  source "bamboo.init.erb"
  mode   "0755"
  notifies :restart, "service[bamboo]", :delayed
end

template "bamboo-init.properties" do
  path "#{node['bamboo']['install_path']}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties"
  source "bamboo-init.properties.erb"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode 0644
  variables({
         "bamboo_home" => node['bamboo']['bamboo_home']
            })
  notifies :restart, "service[bamboo]", :delayed
end

template "seraph-config.xml" do
  path "#{node['bamboo']['install_path']}/atlassian-bamboo/WEB-INF/classes/seraph-config.xml"
  source "seraph-config.xml.erb"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode 0644
  notifies :restart, "service[bamboo]", :delayed
end

template "#{node['bamboo']['install_path']}/bin/setenv.sh" do
  source "setenv.sh.erb"
  owner  node[:bamboo][:user]
  mode   "0755"
  notifies :restart, "service[bamboo]", :delayed
end

service "bamboo" do
  supports :status => true, :restart => true, :start => true, :stop => true
  action :enable
end

# needed for jasper reports and solve pdf and font problems
package "libstdc++5" do
  action :install
end

#TODO: fix backup
#package "ruby1.9.1-dev" do
#  action :install
#end
#needed for nokogiri
package "libxml2-dev" do
  action :install
end

package "libxslt-dev" do
  action :install
end

include_recipe "backup"

backup_install node[:name]
backup_generate_config node[:name]
gem_package "fog" do
  version "> 1.9.0"
end
backup_generate_model "mysql" do
  description "Our shard"
  backup_type "database"
  database_type "MySQL"
  store_with({"engine" => "Local", "settings" => { "local.path" => "/opt/backup", "local.keep" => "5", } } )
  #store_with({"engine" => "S3", "settings" => { "s3.access_key_id" => "1c6c6f540fba4f3fa62dc69233a454f2", "s3.secret_access_key" => "370d72a9aba54e66bbc2fdf110e06e08", "s3.provider" => "http://s3.eden.klm.com/", "s3.region" => "", "s3.bucket" => "sample", "s3.path" => "/", "s3.keep" => 10 } } )
  options({"db.host" => "\"localhost\"", "db.username" => "\"#{node['bamboo']['jdbc_username']}\"", "db.password" => "\"#{node['bamboo']['jdbc_password']}\"", "db.name" => "\"bamboo\""})
  action :backup
end

if (node[:bamboo][:graylog])
  include_recipe "graylog"
end

