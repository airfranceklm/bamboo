site :opscode

metadata
cookbook 'backup', git: 'http://stash.eden.klm.com/scm/chef/backup.git'
cookbook 'mysql_connector', github: 'bflad/chef-mysql_connector', protocol: :https

group :integration do
  cookbook "apt"
  cookbook "java"
  cookbook "backup", path: '../backup'
end
