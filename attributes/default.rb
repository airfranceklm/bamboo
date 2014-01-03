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
default[:bamboo][:bamboo_home] = '/opt/data/bamboo/'
default[:bamboo][:install_path] = '/opt/bamboo'
default[:bamboo][:external_data] = true
default[:bamboo][:home_path] = "/home/bamboo"

default[:bamboo][:name] = 'bamboo'
default[:bamboo][:version] = '5.1.1'
default[:bamboo][:checksum] = '8ebb5fd045cef2765fde13e3f3b88e48da7262f2508ce209a24e9a446c761b8b'
default[:bamboo][:download_url] = "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-#{node[:bamboo][:version]}.tar.gz"

default[:bamboo][:jdbc_username] = 'bamboo'
default[:bamboo][:jdbc_password] = 'bamboo'

default[:bamboo][:mysql] = true

default[:bamboo][:jvm][:minimum_memory] = "512m"
default[:bamboo][:jvm][:maximum_memory] = "2048m"
default[:bamboo][:jvm][:maximum_permgen] = "256m"
default[:bamboo][:jvm][:support_args] = ""

default[:bamboo][:user] = "bamboo"
default[:bamboo][:group] = "bamboo"

default[:bamboo][:agent][:additional_path] = "/opt/rbenv/shims"

#TODO: ssl yes or no
default[:bamboo][:tomcat][:keyAlias] = "tomcat"
default[:bamboo][:tomcat][:keystoreFile] = "#{node[:bamboo][:bamboo_home]}/.keystore"
default[:bamboo][:tomcat][:keystorePass] = "changeit"
default[:bamboo][:tomcat][:port] = "8085"
default[:bamboo][:tomcat][:ssl_port] = "8443"

# graylog2
default[:bamboo][:graylog][:enabled] = "true"
default[:bamboo][:graylog][:facility] = "bamboo"
default[:bamboo][:graylog][:host] = "kl12c0y5.is.klmcorp.net"
default[:bamboo][:graylog][:origin] = node[:fqdn]

# backup to s3
default[:bamboo][:backup][:enabled] = "true"