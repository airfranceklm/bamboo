#
# Cookbook Name:: bamboo
# Attributes:: apache2
#
# Copyright 2012-2013
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# use mpm for eventh ttps://httpd.apache.org/docs/2.4/mod/event.html
if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 13.10
  default['apache']['mpm'] = 'event'
end

# Defaults are automatically selected from fqdn and hostname via helper functions
default['bamboo']['apache2']['access_log']  = ''
default['bamboo']['apache2']['error_log']   = ''
default['bamboo']['apache2']['port']        = 80

# Defaults are automatically selected from fqdn and hostname via helper functions
default['bamboo']['apache2']['template_cookbook']   = 'bamboo'
default['bamboo']['apache2']['virtual_host_name']   = nil
default['bamboo']['apache2']['virtual_host_alias']  = nil
default['bamboo']['apache2']['error_docs']['e503']  = ''

default['bamboo']['apache2']['ssl']['access_log'] = ''
default['bamboo']['apache2']['ssl']['error_log']  = ''
default['bamboo']['apache2']['ssl']['chain_file'] = ''
default['bamboo']['apache2']['ssl']['port']       = 443

case node['platform_family']
when 'rhel'
  default['bamboo']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
  default['bamboo']['apache2']['ssl']['key_file']         = '/etc/pki/tls/private/localhost.key'
else
  default['bamboo']['apache2']['ssl']['certificate_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['bamboo']['apache2']['ssl']['key_file']         = '/etc/ssl/private/ssl-cert-snakeoil.key'
end
