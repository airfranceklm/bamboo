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
default[:bamboo][:external_data] = 'true'

default[:bamboo][:version] = '5.0'
default[:bamboo][:download_url] = "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-#{node[:bamboo][:version]}.tar.gz"

default[:bamboo][:jdbc_username] = 'bamboo'
default[:bamboo][:jdbc_password] = 'bamboo'

default[:bamboo][:mysql] = "true"
default[:bamboo][:mysql_connector_version] = '5.1.25'

default[:bamboo][:port] = "80"
default[:bamboo][:xms] = "256m"
default[:bamboo][:xmx] = "512m"
default[:bamboo][:permsize] = "256m"


