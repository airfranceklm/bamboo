name             'bamboo'
maintainer       'Ramon Makkelie, Stephan Oudmaijer'
maintainer_email 'ramonmakkelie@gmail.com, soudmaijer@gmail.com'
license          'Apache 2.0'
description      'Installs and configures Bamboo'
version          '2.0.8'
issues_url       'https://github.com/afklm/bamboo/issues' if respond_to?(:issues_url)
source_url       'https://github.com/afklm/bamboo.git' if respond_to?(:source_url)

recipe 'bamboo::default', 'Installs/configures Atlassian bamboo server with apache2 and database'
recipe 'bamboo::server',  'Installs/configures Atlassian bamboo server'
recipe 'bamboo::agent',   'Installs/configures an Atlassian bamboo agent'
recipe 'bamboo::crowd_sso', 'Configures user authentication with Atlassian Crowd single sign-on'
recipe 'bamboo::upgrade', 'WIP'

chef_version '~> 12'
supports 'ubuntu', '>= 14.04'

# We only test on ubuntu, so debian and ubuntu should be rather safe
%w(debian centos redhat amazon).each do |os|
  supports os
end

# Always specify the version of your dependencies
depends 'apt'
depends 'ark'
depends 'apache2', '= 3.2.1'
depends 'cron'
depends 'patch'
depends 'backup', '= 0.3.0'
depends 'database'
depends 'git'
depends 'java'
depends 'monit'
depends 'mysql', '< 8.0'
depends 'mysql_connector'
depends 'perl'
depends 'mysql2_chef_gem'
depends 'postgresql'
depends 'build-essential'
