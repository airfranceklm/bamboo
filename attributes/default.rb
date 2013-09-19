#
# Cookbook Name:: nova
# Attributes:: default
#
# Author:: Ramon Makkelie
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

# default attributes for all platforms
default[:bamboo][:url] = 'http://bamboo.eden.klm.com'
default[:bamboo][:bamboo_home] = '/mnt/data/bamboo/'
default[:bamboo][:install_path] = '/opt/bamboo/'
default[:bamboo][:external_data] = 'true'

default[:bamboo][:version] = '5.0'
default[:bamboo][:download_url] = "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-#{node[:bamboo][:version]}.tar.gz"

default[:bamboo][:jdbc_username] = 'bamboo'
default[:bamboo][:jdbc_password] = 'bamboo'

default[:bamboo][:mysql] = "true"

default[:bamboo][:jvm][:minimum_memory] = "256m"
default[:bamboo][:jvm][:maximum_memory] = "512m"
default[:bamboo][:jvm][:maximum_permgen] = "256m"
default[:bamboo][:jvm][:support_args] = ""

default[:bamboo][:user] = "bamboo"
default[:bamboo][:group] = "bamboo"

#TODO: ssl yes or no
default['stash']['tomcat']['keyAlias']     = "tomcat"
default['stash']['tomcat']['keystoreFile'] = "#{node['stash']['home_path']}/.keystore"
default['stash']['tomcat']['keystorePass'] = "changeit"
default['stash']['tomcat']['port']         = "8085"
default['stash']['tomcat']['ssl_port']     = "8443"


