name              'bamboo'
maintainer        'CC WD eDEn.'
maintainer_email  'ramon.makkelie@klm.com, stephan.oudmaijer@klm.com'
license           'Apache 2.0'
description       'Installs and configures Bamboo'
long_description   IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.1.0'
recipe            'bamboo::default', 'Installs the bamboo server with optional backup in place and logging to graylog.'
recipe            'bamboo::server', 'Only installs the bamboo server.'
recipe            'bamboo::agent', 'Installs a bamboo agent.'

# We only test on ubuntu, so debian and ubuntu should be rather safe
%w{ debian ubuntu }.each do |os|
  supports os
end

depends 'ark',             '= 0.4.0'
depends 'apache2',         '= 1.8.4'
depends 'backup'
depends 'cron',            '= 1.2.8'
depends 'database',        '= 1.5.2'
depends 'git',             '= 2.7.0'
depends 'java',            '= 1.12.0'
depends 'mysql',           '= 3.0.2'
depends 'mysql_connector', '= 0.4.1'
depends 'perl',            '= 1.2.0'
