#
# Cookbook Name:: bamboo
# Recipe:: server
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

user node[:bamboo][:user] do
  comment "Bamboo Service Account"
  home    node[:bamboo][:home_path]
  shell   "/bin/bash"
  supports :manage_home => true
  system  true
  action  :create
end

directory "#{node[:bamboo][:bamboo_install]}" do
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode "0775"
  action :create
end

directory "#{node[:bamboo][:bamboo_home]}" do
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode "0775"
  action :create
end

include_recipe "java"
include_recipe "ark"

# download bamboo
ark node[:bamboo][:name] do
  url node[:bamboo][:download_url]
  home_dir node[:bamboo][:install_path]
  checksum node[:bamboo][:checksum]
  version node[:bamboo][:version]
  owner node[:bamboo][:user]
  group node[:bamboo][:group]
  notifies :restart, "service[bamboo]", :delayed
end


if (node[:bamboo][:database][:type] == "mysql")
  directory "#{node[:bamboo][:install_path]}/lib" do
    owner  node[:bamboo][:user]
    group  node[:bamboo][:group]
    mode "0775"
    action :create
  end

  mysql_connector_j "#{node[:bamboo][:install_path]}/lib"
end

template "/etc/init.d/bamboo" do
  source "bamboo.init.erb"
  mode   "0755"
  notifies :restart, "service[bamboo]", :delayed
end

template "bamboo-init.properties" do
  path "#{node[:bamboo][:install_path]}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties"
  source "bamboo-init.properties.erb"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode 0644
  notifies :restart, "service[bamboo]", :delayed
end

template "seraph-config.xml" do
  path "#{node[:bamboo][:install_path]}/atlassian-bamboo/WEB-INF/classes/seraph-config.xml"
  source "seraph-config.xml.erb"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode 0644
  notifies :restart, "service[bamboo]", :delayed
end

template "#{node[:bamboo][:install_path]}/bin/setenv.sh" do
  source "setenv.sh.erb"
  owner  node[:bamboo][:user]
  mode   "0755"
  notifies :restart, "service[bamboo]", :delayed
end

service "bamboo" do
  supports :status => true, :restart => true, :start => true, :stop => true
  action :enable
end