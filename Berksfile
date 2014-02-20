site :opscode

metadata
cookbook 'backup', github: 'ramonskie/backup', protocol: :https
cookbook 'mysql_connector', github: 'bflad/chef-mysql_connector', protocol: :https

group :integration do
  cookbook "apt"
  cookbook "java"
end
