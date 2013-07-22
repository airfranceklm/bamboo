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
#

include_recipe "java"

# mount harddisk if true
if (node[:bamboo][:external_data])
  directory "/mnt/data" do
    owner "root"
    group "root"
    mode "0775"
    action :create
  end
  mount "/mnt/data/" do
    device "/dev/vdc1"
    fstype "ext4"
  end
end

# create bamboo home_dir

# download bamboo

remote_file "/opt/atlassian-bamboo-#{node['bamboo']['version']}.tar.gz" do
  source "#{node['bamboo']['download_url']}"
  mode "0644"
  not_if { ::File.exists?("/opt/atlassian-bamboo-#{node['bamboo']['version']}.tar.gz") }
end

# create dir releases
execute "tar -xzf /opt/atlassian-bamboo-#{node['bamboo']['version']}.tar.gz /opt/" do
  not_if { ::File.directory?("/opt/atlassian-bamboo-#{node['bamboo']['version']}/") }
end

# symlink from deployed release to current
# create dir bamboo/current
link "/opt/bamboo" do
  to "/opt/atlassian-bamboo-#{node['bamboo']['version']}"
end


# make symlink from wrapper/start-bamboo to /etc/init.d/bamboo
# add start service at system start
link "/etc/init.d/bamboo" do
  to "/opt/bamboo/wrapper/start-bamboo"
end



# edit database_mysql.rb
# install and configure mysql
# insert mysql jdbc lib in wrapper/lib




