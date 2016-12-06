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
include_recipe 'ark'
include_recipe 'java'
include_recipe 'patch'

# Create group and users
group node[:bamboo][:group] do
  action :create
end

user node[:bamboo][:user] do
  comment 'Bamboo Service Account'
  home node[:bamboo][:user_home]
  shell '/bin/bash'
  supports :manage_home => true
  gid node[:bamboo][:group]
  system true
  action :create
end

# Create required directories
directory node[:bamboo][:data_dir] do
  owner node[:bamboo][:user]
  group node[:bamboo][:group]
  mode '0775'
  action :create
end

# Download and install the bamboo package
ark node[:bamboo][:name] do
  url      node[:bamboo][:download_url]
  home_dir node[:bamboo][:home_dir]
  checksum node[:bamboo][:checksum]
  version  node[:bamboo][:version]
  owner    node[:bamboo][:user]
  group    node[:bamboo][:group]
  notifies :restart, 'service[bamboo]', :delayed
end

if node[:bamboo][:database][:type] == 'mysql'
  directory "#{node[:bamboo][:home_dir]}/lib" do
    owner node[:bamboo][:user]
    group node[:bamboo][:group]
    mode '0775'
    action :create
  end

  mysql_connector_j "#{node[:bamboo][:home_dir]}/lib"
end

# Install templates
template '/etc/init.d/bamboo' do
  source 'bamboo.init.erb'
  mode '0755'
  notifies :restart, 'service[bamboo]', :delayed
end

replace_line "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties" do
  replace(/.*bamboo.home=.*/)
  with "bamboo.home=#{node[:bamboo][:data_dir]}"
end

template 'seraph-config.xml' do
  path "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/seraph-config.xml"
  source 'seraph-config.xml.erb'
  owner node[:bamboo][:user]
  group node[:bamboo][:group]
  mode '0644'
  notifies :restart, 'service[bamboo]', :delayed
end

template "#{node[:bamboo][:home_dir]}/bin/setenv.sh" do
  source 'setenv.sh.erb'
  owner node[:bamboo][:user]
  mode '0755'
  notifies :restart, 'service[bamboo]', :delayed
end

template "#{node[:bamboo][:home_dir]}/bin/stop-bamboo.sh" do
  source 'stop-bamboo.sh.erb'
  owner node[:bamboo][:user]
  mode '0755'
end

# Create and enable service
service 'bamboo' do
  supports :status => true, :restart => true, :start => true, :stop => true
  action :enable
end
