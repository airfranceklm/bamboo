#
# Cookbook Name:: bamboo
# Recipe:: upgrade
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

service 'Stopping bamboo' do
  service_name 'bamboo'
  action :stop
end

file '/etc/init/bamboo' do
  action :delete
end

# TODO: its a symlink so could also be a dir
file '/opt/bamboo' do
  action :delete
end

include_recipe 'bamboo::apache2'

ruby_block 'remove_recipe_bamboo_upgrade' do
  block { node.run_list.remove('recipe[bamboo::upgrade]') }
end
