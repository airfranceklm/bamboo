#
# Cookbook Name:: bamboo
# Recipe:: agent
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
include_recipe "java"

# Create group and users
group node[:bamboo][:group] do
  action :create
end

user node[:bamboo][:user] do
  comment "Bamboo Service Account"
  gid     node[:bamboo][:group]
  home    node[:bamboo][:user_home]
  supports :manage_home => true
  shell   "/bin/bash"
  system  true
  action  :create
end

# Create required directories
directory "#{node[:bamboo][:home_dir]}" do
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode "0775"
  action :create
end

directory "#{node[:bamboo][:data_dir]}" do
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode "0775"
  action :create
end

# Download and install the bamboo package
remote_file "#{node[:bamboo][:home_dir]}/atlassian-bamboo-agent-installer.jar" do
  source "#{node[:bamboo][:url]}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-#{node[:bamboo][:version]}.jar"
  mode "0644"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  not_if { ::File.exists?("#{node[:bamboo][:home_dir]}/atlassian-bamboo-agent-installer.jar") }
end

execute "java -Ddisable_agent_auto_capability_detection=#{node[:bamboo][:agent][:disable_agent_auto_capability_detection]} -Dbamboo.home=#{node[:bamboo][:data_dir]} -jar #{node[:bamboo][:home_dir]}/atlassian-bamboo-agent-installer.jar #{node[:bamboo][:url]}/agentServer/ install" do
  user   node[:bamboo][:user]
  group  node[:bamboo][:group]
  not_if { ::File.exists?("#{node[:bamboo][:data_dir]}/installer.properties") }
end

# Install templates
template "bamboo-agent.sh" do
  path "#{node[:bamboo][:data_dir]}/bin/bamboo-agent.sh"
  source "bamboo-agent.sh.erb"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode 0755
  notifies :restart, "service[bamboo-agent]", :delayed
end

link "/etc/init.d/bamboo-agent" do
  to "#{node[:bamboo][:data_dir]}/bin/bamboo-agent.sh"
end

# Create and enable service
service "bamboo-agent" do
  supports :restart => true, :status => true, :start => true, :stop => true
  action [:enable, :start]
end

# Setup monit
package "monit" do
  action :install
end

template 'procfile.monitrc' do
  path "/etc/monit/conf.d/bamboo-agent.conf"
  owner 'root'
  group 'root'
  mode '0644'
end