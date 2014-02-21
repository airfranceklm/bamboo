#
# Cookbook Name:: nova
# Attributes:: default
#
# Author:: Ramon Makkelie, Stephan Oudmaijer
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
default[:bamboo][:url]                            = 'http://localhost'                  # bamboo server URL
default[:bamboo][:home_dir]                       = '/opt/bamboo'                       # bamboo installation directory
default[:bamboo][:data_dir]                       = '/var/bamboo'                       # bamboo data directory
default[:bamboo][:user]                           = "bamboo"                            # bamboo user
default[:bamboo][:group]                          = "bamboo"                            # bamboo group
default[:bamboo][:user_home]                      = "/home/bamboo"                      # bamboo system user home directory
default[:bamboo][:name]                           = 'bamboo'                            # bamboo application/service name
default[:bamboo][:version]                        = '5.3'
default[:bamboo][:download_url]                   = "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-#{node[:bamboo][:version]}.tar.gz"
default[:bamboo][:checksum] =
case node[:bamboo][:version]
  when '5.1.1' then '8ebb5fd045cef2765fde13e3f3b88e48da7262f2508ce209a24e9a446c761b8b'
  when '5.3'   then '814e9bc11a48ca475621de94b9b22abb4be6b9b6997967b1cc568492f0220064'
end

default[:bamboo][:database][:type]                = 'mysql'
default[:bamboo][:database][:host]                = 'localhost'
default[:bamboo][:database][:port]                = 3306
default[:bamboo][:database][:name]                = 'bamboo'
default[:bamboo][:database][:user]                = 'bamboo'
default[:bamboo][:database][:password]            = 'bamboo'

default[:bamboo][:jvm][:minimum_memory]           = "512m"
default[:bamboo][:jvm][:maximum_memory]           = "2048m"
default[:bamboo][:jvm][:maximum_permgen]          = "256m"
default[:bamboo][:jvm][:support_args]             = ""

default[:bamboo][:agent][:disable_agent_auto_capability_detection] = true
default[:bamboo][:agent][:additional_path]        = ""

# If you're authenticating against a Crowd server you can use this authenticator for single sign-on.
# Enable it after configuring your Crowd properties through user management and restart Bamboo. It does not support
# Crowd property changes at runtime. If you need to switch back to local users, revert the change and
# restart Bamboo again.
default[:bamboo][:crowd]                          = false

# graylog2 integrations
default[:bamboo][:graylog][:enabled]              = false
default[:bamboo][:graylog][:facility]             = "bamboo"
default[:bamboo][:graylog][:host]                 = "change_me"
default[:bamboo][:graylog][:origin]               = node[:fqdn]

# backup to an s3 bucket
default[:bamboo][:backup][:enabled]               = false
default[:bamboo][:backup][:s3_host]               = 's3.amazonaws.com'
default[:bamboo][:backup][:s3_scheme]             = 'http'
default[:bamboo][:backup][:s3_port]               = 80
default[:bamboo][:backup][:s3_access_key_id]      = 'change_me'
default[:bamboo][:backup][:s3_secret_access_key]  = 'change_me'
default[:bamboo][:backup][:s3_bucket]             = 'change_me'
