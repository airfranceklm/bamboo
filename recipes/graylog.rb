#
# Cookbook Name:: bamboo
# Recipe:: graylog
# Author:: Stephan Oudmaijer
#
# Copyright 2013
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
cookbook_file "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/lib/gelfj-1.1.2.jar" do
  source 'gelfj-1.1.2.jar'
  owner node[:bamboo][:user]
  group node[:bamboo][:group]
  mode '0775'
end

cookbook_file "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/lib/json-simple-1.1.jar" do
  source 'json-simple-1.1.jar'
  owner node[:bamboo][:user]
  group node[:bamboo][:group]
  mode '0775'
end

template 'log4j.properties' do
  path "#{node[:bamboo][:home_dir]}/atlassian-bamboo/WEB-INF/classes/log4j.properties"
  source 'log4j.properties.erb'
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  mode 0644
  notifies :restart, 'service[bamboo]', :delayed
end
