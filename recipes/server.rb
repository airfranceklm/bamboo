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

execute 'configcacerts' do
  command '/var/lib/dpkg/info/ca-certificates-java.postinst configure'
  only_if { node['platform'] == 'ubuntu' && node['platform_version'] == '14.04' }
  only_if { node['java']['install_flavor'] == 'openjdk' }
end

# Create group and users
group node['bamboo']['group'] do
  action :create
end

user node['bamboo']['user'] do
  comment 'Bamboo Service Account'
  home node['bamboo']['user_home']
  shell '/bin/bash'
  supports :manage_home => true
  gid node['bamboo']['group']
  system true
  action :create
end

# Create required directories
directory node['bamboo']['data_dir'] do
  owner node['bamboo']['user']
  group node['bamboo']['group']
  mode '0755'
  action :create
  recursive true
end

Chef::Resource::Ark.send(:include, Bamboo::Helpers)

ark 'bamboo' do
  url bamboo_artifact_url
  home_dir node['bamboo']['home_dir']
  checksum bamboo_artifact_checksum
  version node['bamboo']['version']
  owner node['bamboo']['user']
  group node['bamboo']['group']
  notifies :restart, 'service[bamboo]', :delayed
end

if node['bamboo']['database']['type'] == 'mysql'
  directory "#{node['bamboo']['home_dir']}/lib" do
    owner node['bamboo']['user']
    group node['bamboo']['group']
    mode '0775'
    action :create
  end

  mysql_connector_j "#{node['bamboo']['home_dir']}/lib"
end

if node['init_package'] == 'systemd'

  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  template '/etc/systemd/system/bamboo.service' do
    source 'bamboo.service.erb'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    notifies :restart, 'service[bamboo]', :delayed
    variables(
      :user => node['bamboo']['user'],
      :group => node['bamboo']['group'],
      :home_dir => node['bamboo']['home_dir']
    )
  end

else
  # install an init.d script
  template '/etc/init.d/bamboo' do
    source 'bamboo.init.erb'
    mode '0755'
    notifies :restart, 'service[bamboo]', :delayed
    variables(
      :user => node['bamboo']['user'],
      :home_dir => node['bamboo']['home_dir'],
      :data_dir => node['bamboo']['data_dir'],
      :name => node['bamboo']['name']
    )
  end
end

template "#{node['bamboo']['home_dir']}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties" do
  source 'bamboo-init.properties.erb'
  owner node['bamboo']['user']
  mode '0644'
  notifies :restart, 'service[bamboo]', :delayed
  variables(
    :data_dir => node['bamboo']['data_dir']
  )
end

template "#{node['bamboo']['home_dir']}/bin/setenv.sh" do
  source 'setenv.sh.erb'
  owner node['bamboo']['user']
  mode '0755'
  notifies :restart, 'service[bamboo]', :delayed
  variables(
    :support_args => node['bamboo']['jvm']['support_args'],
    :minimum_memory => node['bamboo']['jvm']['minimum_memory'],
    :maximum_memory => node['bamboo']['jvm']['maximum_memory'],
    :disable_agent_auto_capability_detection => node['bamboo']['agent']['disable_agent_auto_capability_detection'],
    :data_dir => node['bamboo']['data_dir'],
    :name => node['bamboo']['name'],
    :catalina_opts => node['bamboo']['catalina']['opts']
  )
end

template "#{node['bamboo']['home_dir']}/bin/stop-bamboo.sh" do
  source 'stop-bamboo.sh.erb'
  owner node['bamboo']['user']
  mode '0755'
  variables(
    :data_dir => node['bamboo']['data_dir'],
    :name => node['bamboo']['name']
  )
end

# Create and enable service
service 'bamboo' do
  supports :status => true, :restart => true, :start => true, :stop => true
  action :enable
end
