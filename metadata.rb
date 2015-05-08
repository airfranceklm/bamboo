name                          'bamboo'
maintainer                    'Ramon Makkelie, Stephan Oudmaijer'
maintainer_email              'ramonmakkelie@gmail.com, soudmaijer@gmail.com'
license                       'Apache 2.0'
description                   'Installs and configures Bamboo'
version                       '1.4.2'

recipe 'bamboo::default',     'Installs the bamboo server with optional backup in place and logging to graylog.'
recipe 'bamboo::server',      'Only installs the bamboo server.'
recipe 'bamboo::agent',       'Installs a bamboo agent.'

# We only test on ubuntu, so debian and ubuntu should be rather safe
%w( debian ubuntu centos redhat amazon ).each do |os|
  supports os
end

# Always specify the version of your dependencies
depends 'apt'
depends 'ark',                '~> 0.9.0'
depends 'apache2'
depends 'backup',             '~> 0.2.3'
depends 'cron',               '~> 1.2.8'
depends 'database',           '~> 4.0.6'
depends 'git',                '~> 2.7.0'
depends 'java',               '~> 1.22.0'
depends 'mysql',              '~> 6.0'
depends 'mysql_connector',    '~> 0.7.2'
depends 'perl',               '~> 1.2.0'
depends 'mysql2_chef_gem',    '~> 1.0'
