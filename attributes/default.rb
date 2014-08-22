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
default[:bamboo][:version]                        = '5.6.0'
default[:bamboo][:download_url]                   = "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-#{node[:bamboo][:version]}.tar.gz"
default[:bamboo][:checksum] =
case node[:bamboo][:version]
when '5.1.1' then '8ebb5fd045cef2765fde13e3f3b88e48da7262f2508ce209a24e9a446c761b8b'
when '5.3'   then '814e9bc11a48ca475621de94b9b22abb4be6b9b6997967b1cc568492f0220064'
when '5.4.1' then '61657B5B585613E148EDA68B778ED94D782B31869C38E0170EE5B1EB4B332FA6'
when '5.5.1' then '1a9229158d7347d8debeca824ce1511d40e1baa8514309aea576e0c07d73cf19'
when '5.6.0' then '71c72e094fbcc258aa0f0cf74c652e0d63887c35b900f563bc672db99c5d9b98'
end

default[:bamboo][:database][:type]                = 'mysql'
default[:bamboo][:database][:host]                = 'localhost'
default[:bamboo][:database][:port]                = 3306
default[:bamboo][:database][:name]                = 'bamboo'
default[:bamboo][:database][:user]                = 'bamboo'
default[:bamboo][:database][:password]            = 'bamboo'
default[:mysql][:bind_address]                    = 'localhost'

default[:bamboo][:jvm][:minimum_memory]           = '512m'
default[:bamboo][:jvm][:maximum_memory]           = '2048m'
default[:bamboo][:jvm][:maximum_permgen]          = '256m'
default[:bamboo][:jvm][:support_args]             = ''

default[:java][:install_flavor]                   = 'openjdk'
default[:java][:jdk_version]                      = '7'

# bamboo agent
default[:bamboo][:agent][:home_dir]               = '/opt/bamboo'                       # bamboo installation directory
default[:bamboo][:agent][:data_dir]               = '/var/bamboo'                       # bamboo data directory
default[:bamboo][:agent][:user]                   = 'bamboo'                            # bamboo user
default[:bamboo][:agent][:group]                  = 'bamboo'                            # bamboo group
default[:bamboo][:agent][:user_home]              = '/home/bamboo'                      # bamboo system user home directory
default[:bamboo][:agent][:data_dir]               = '/var/bamboo'                       # bamboo data directory
default[:bamboo][:agent][:disable_agent_auto_capability_detection] = true
default[:bamboo][:agent][:additional_path]        = ''
default[:bamboo][:agent][:attributes]                = {
  'system.jdk.JDK\ 1.7'                           => '/usr/lib/jvm/java-7-openjdk-amd64',
  'system.git.executable'                         => '/usr/bin/git',
  'system.builder.mvn3.Maven\ 3'                    => '/opt/maven/bin/'
}

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
default[:bamboo][:backup][:enabled]               = false
default[:bamboo][:backup][:s3_host]               = 's3.amazonaws.com'
default[:bamboo][:backup][:s3_scheme]             = 'http'
default[:bamboo][:backup][:s3_port]               = 80
default[:bamboo][:backup][:s3_access_key_id]      = 'change_me'
default[:bamboo][:backup][:s3_secret_access_key]  = 'change_me'
default[:bamboo][:backup][:s3_bucket]             = 'change_me'
