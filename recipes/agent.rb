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

remote_file "#{node[:bamboo][:bamboo_install]}/atlassian-bamboo-agent-installer.jar" do
  source "#{node[:bamboo][:url]}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-#{node[:bamboo][:version]}.jar"
  mode "0644"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  not_if { ::File.exists?("#{node[:bamboo][:bamboo_install]}/atlassian-bamboo-agent-installer.jar") }
end

execute "java -DDISABLE_AGENT_AUTO_CAPABILITY_DETECTION=#{node[:bamboo][:agent][:disable_agent_auto_capability_detection]} -Dbamboo.home=#{node[:bamboo][:bamboo_home]} -jar #{node[:bamboo][:bamboo_install]}/atlassian-bamboo-agent-installer.jar #{node[:bamboo][:url]}/agentServer/ install" do
  user   node[:bamboo][:user]
  group  node[:bamboo][:group]
  not_if { ::File.exists?("#{node[:bamboo][:bamboo_home]}/installer.properties") }
end

template "bamboo-agent.sh" do
  path "#{node[:bamboo][:bamboo_home]}/bin/bamboo-agent.sh"
  source "bamboo-agent.sh.erb"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode 0755
  notifies :restart, "service[bamboo-agent]", :delayed
end

link "/etc/init.d/bamboo-agent" do
  to "#{node[:bamboo][:bamboo_home]}/bin/bamboo-agent.sh"
end

service "bamboo-agent" do
  supports :restart => true, :status => true, :start => true, :stop => true
  action [:enable, :start]
end

package "monit" do
  action :install
end

template 'procfile.monitrc' do
  path "/etc/monit/conf.d/bamboo-agent.conf"
  owner 'root'
  group 'root'
  mode '0644'
end