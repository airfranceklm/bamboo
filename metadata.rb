name                          'bamboo'
maintainer                    'Ramon Makkelie, Stephan Oudmaijer'
maintainer_email              'ramonmakkelie@gmail.com, soudmaijer@gmail.com'
license                       'Apache 2.0'
description                   'Installs and configures Bamboo'
version                       '1.3.0'

recipe 'bamboo::default',     'Installs the bamboo server with optional backup in place and logging to graylog.'
recipe 'bamboo::server',      'Only installs the bamboo server.'
recipe 'bamboo::agent',       'Installs a bamboo agent.'

# We only test on ubuntu, so debian and ubuntu should be rather safe
%w( debian ubuntu centos redhat amazon ).each do |os|
  supports os
end

# Always specify the version of your dependencies
depends 'apt'
depends 'ark'
depends 'apache2'
depends 'backup'
depends 'cron'
depends 'database'
depends 'git'
depends 'java'
depends 'mysql'
depends 'mysql_connector'
depends 'perl'
