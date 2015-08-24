#
# Cookbook Name:: bamboo
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

# bamboo server
default[:bamboo][:url]                            = 'http://localhost'                  # bamboo server URL
default[:bamboo][:home_dir]                       = '/opt/bamboo'                       # bamboo installation directory
default[:bamboo][:data_dir]                       = '/var/bamboo'                       # bamboo data directory
default[:bamboo][:user]                           = 'bamboo'                            # bamboo user
default[:bamboo][:group]                          = 'bamboo'                            # bamboo group
default[:bamboo][:user_home]                      = '/home/bamboo'                      # bamboo system user home directory
default[:bamboo][:name]                           = 'bamboo'                            # bamboo application/service name
default[:bamboo][:version]                        = '5.9.1'
default[:bamboo][:download_url]                   = "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-#{node[:bamboo][:version]}.tar.gz"
default[:bamboo][:checksum] =
case node[:bamboo][:version]
when '5.1.1' then '8ebb5fd045cef2765fde13e3f3b88e48da7262f2508ce209a24e9a446c761b8b'
when '5.3'   then '814e9bc11a48ca475621de94b9b22abb4be6b9b6997967b1cc568492f0220064'
when '5.4.1' then '61657B5B585613E148EDA68B778ED94D782B31869C38E0170EE5B1EB4B332FA6'
when '5.5.1' then '1a9229158d7347d8debeca824ce1511d40e1baa8514309aea576e0c07d73cf19'
when '5.6.0' then '71c72e094fbcc258aa0f0cf74c652e0d63887c35b900f563bc672db99c5d9b98'
when '5.6.2' then '57737a00207642e7be4ceea7b702e30e1caccaaa51e08699c2c9ae588e4c88b3'
when '5.7.2' then 'b378500ea61803333fc27b0a42cfbdfbce5dccc75cead0b464dbc4e5e0bddb17'
when '5.8.1' then 'bb691d22273ceaa999eb435dfb4e8d697c3c803505218845bf5785ec2785cbd8'
when '5.9.1' then '0b7e84214862c4afd7dbc839c2c4045d28e554c383d93660b6d2e0bce42898d3'
when '5.9.4' then '8905a4750ca6d73feefbcc58d91e05be3bd60e2c60ca422f092a080f7263bdb2'
end

default[:bamboo][:database][:external]            = false
default[:bamboo][:database][:type]                = 'mysql'
case node[:bamboo][:database][:type]
when 'mysql'
  default[:bamboo][:database][:version]           = '5.6'
  default[:bamboo][:database][:host]              = '127.0.0.1'
  default[:bamboo][:database][:port]              = 3306
when 'postgresql'
  default[:postgresql][:version]                  = '9.4'
  default[:bamboo][:database][:host]              = 'localhost'
  default[:bamboo][:database][:port]              = 5432
  default[:postgresql][:config_pgtune][:db_type]  = 'web'
end
default[:bamboo][:database][:name]                = 'bamboo'
default[:bamboo][:database][:user]                = 'bamboo'
default[:bamboo][:database][:password]            = 'bamboo'
default[:mysql][:server_root_password]            = 'changeme'
default[:postgresql][:password][:postgres]        = 'changeme'

default[:bamboo][:jvm][:minimum_memory]           = '512m'
default[:bamboo][:jvm][:maximum_memory]           = '2048m'
default[:bamboo][:jvm][:maximum_permgen]          = '256m'
default[:bamboo][:jvm][:support_args]             = ''

default[:bamboo][:catalina][:opts]                = ''

default[:java][:install_flavor]                   = 'oracle'
default[:java][:jdk_version]                      = '8'
default[:java][:oracle][:accept_oracle_download_terms] = true

# bamboo agent
default[:bamboo][:agent][:home_dir]               = '/opt/bamboo'                       # bamboo installation directory
default[:bamboo][:agent][:data_dir]               = '/var/bamboo'                       # bamboo data directory
default[:bamboo][:agent][:user]                   = 'bamboo'                            # bamboo user
default[:bamboo][:agent][:group]                  = 'bamboo'                            # bamboo group
default[:bamboo][:agent][:user_home]              = '/home/bamboo'                      # bamboo system user home directory
default[:bamboo][:agent][:disable_agent_auto_capability_detection] = true
default[:bamboo][:agent][:additional_path]        = ''
default[:bamboo][:agent_capabilities]              = {}

# If you're authenticating against a Crowd server you can use this authenticator for single sign-on.
# Enable it after configuring your Crowd properties through user management and restart Bamboo. It does not support
# Crowd property changes at runtime. If you need to switch back to local users, revert the change and
# restart Bamboo again.
default[:bamboo][:crowd]                          = false

# graylog2 integrations
default[:bamboo][:graylog][:enabled]              = false
default[:bamboo][:graylog][:facility]             = 'bamboo'
default[:bamboo][:graylog][:host]                 = 'change_me'
default[:bamboo][:graylog][:origin]               = node[:fqdn]

# backup to an s3 bucket
default[:bamboo][:backup][:ceph]                  = false
default[:bamboo][:backup][:enabled]               = false
default[:bamboo][:backup][:s3_host]               = 's3.amazonaws.com'
default[:bamboo][:backup][:s3_scheme]             = 'http'
default[:bamboo][:backup][:s3_port]               = 80
default[:bamboo][:backup][:s3_access_key_id]      = 'change_me'
default[:bamboo][:backup][:s3_secret_access_key]  = 'change_me'
default[:bamboo][:backup][:s3_bucket]             = 'change_me'

# damn postgresql:ruby recipe still builds at compile time
default[:apt][:ompile_time_update] = true
default[:build_essential][:compiletime] = true
