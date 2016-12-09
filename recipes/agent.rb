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
include_recipe 'java'

# Create group and users
group node[:bamboo][:agent][:group] do
  action :create
end

user node[:bamboo][:agent][:user] do
  comment 'Bamboo Service Account'
  gid  node[:bamboo][:agent][:group]
  home node[:bamboo][:agent][:user_home]
  supports :manage_home => true
  shell  '/bin/bash'
  system true
  action :create
end

# Create required directories
directory node[:bamboo][:agent][:home_dir] do
  owner   node[:bamboo][:agent][:user]
  group   node[:bamboo][:agent][:group]
  mode '0775'
  action :create
end

directory node[:bamboo][:agent][:data_dir] do
  owner   node[:bamboo][:agent][:user]
  group   node[:bamboo][:agent][:group]
  mode '0775'
  action :create
end

# Download and install the bamboo package
remote_file "#{node[:bamboo][:agent][:home_dir]}/atlassian-bamboo-agent-installer.jar" do
  source "#{node[:bamboo][:url]}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-#{node[:bamboo][:version]}.jar"
  mode '0644'
  owner  node[:bamboo][:agent][:user]
  group  node[:bamboo][:agent][:group]
  not_if { ::File.exist?("#{node[:bamboo][:agent][:home_dir]}/atlassian-bamboo-agent-installer.jar") }
end

execute "java -Ddisable_agent_auto_capability_detection=#{node[:bamboo][:agent][:disable_agent_auto_capability_detection]} -Dbamboo.home=#{node[:bamboo][:agent][:data_dir]} -jar #{node[:bamboo][:agent][:home_dir]}/atlassian-bamboo-agent-installer.jar #{node[:bamboo][:url]}/agentServer/ install" do
  user  node[:bamboo][:agent][:user]
  group node[:bamboo][:agent][:group]
  not_if { ::File.exist?("#{node[:bamboo][:agent][:data_dir]}/installer.properties") }
end

# make a service out of it
if %w(mac_os_x).include?(node['platform_family'])

  template '/Library/LaunchDaemons/bamboo-agent.plist' do
    source 'bamboo-agent.plist.erb'
    owner 'root'
    group 'wheel'
    mode '0644'
    variables(
      :username => node[:bamboo][:agent][:user],
      :data_dir => node[:bamboo][:agent][:data_dir]
    )
  end

elsif node['init_package'] == 'systemd'

  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  template '/etc/systemd/system/bamboo-agent.service' do
    source 'bamboo-agent.service.erb'
    owner 'root'
    group 'root'
    mode 00755
    action :create
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    notifies :restart, 'service[bamboo-agent]', :delayed
  end

else
  # when using a previous version of this cookbook remove the link
  if File.symlink?('/etc/init.d/bamboo-agent')
    delete_resource(:template, 'bamboo-agent.sh')

    link '/etc/init.d/bamboo-agent' do
      to "#{node[:bamboo][:agent][:data_dir]}/bin/bamboo-agent.sh"
      action :delete
    end
  end

  # install init.d script
  template '/etc/init.d/bamboo-agent' do
    source 'bamboo-agent.init.erb'
    owner 'root'
    group 'root'
    mode 00755
    action :create
    notifies :restart, 'service[bamboo-agent]', :delayed
  end
end

capabilities = node[:bamboo][:agent_capabilities]
template 'bamboo-capabilities.properties' do
  path "#{node[:bamboo][:agent][:data_dir]}/bin/bamboo-capabilities.properties"
  source 'bamboo-capabilities.properties.erb'
  owner  node[:bamboo][:agent][:user]
  group  node[:bamboo][:agent][:group]
  mode '0644'
  variables(
    :options => capabilities
  )
  notifies :restart, 'service[bamboo-agent]', :delayed
end

template 'wrapper.conf' do
  path "#{node[:bamboo][:agent][:data_dir]}/conf/wrapper.conf"
  source 'agent-wrapper.conf.erb'
  owner  node[:bamboo][:agent][:user]
  group  node[:bamboo][:agent][:group]
  mode '0644'
  notifies :restart, 'service[bamboo-agent]', :delayed
end

# create and enable service
service 'bamboo-agent' do
  supports :restart => true, :status => true, :start => true, :stop => true
  provider Chef::Provider::Service::Macosx if node[:platform_family] == 'mac_os_x'
  action [:enable, :start]
end

# setup monit
package 'monit' do
  action :install
  not_if { node[:platform_family] == 'mac_os_x' }
end

template 'procfile.monitrc' do
  path   '/etc/monit/conf.d/bamboo-agent.conf'
  owner  'root'
  group  'root'
  mode '0644'
  notifies :restart, 'service[monit]', :delayed unless node[:platform_family] == 'mac_os_x'
  not_if { node[:platform_family] == 'mac_os_x' }
end

# create and enable service
service 'monit' do
  supports :restart => true, :status => true, :start => true, :stop => true
  action [:enable, :start]
  not_if { node[:platform_family] == 'mac_os_x' }
end
