site :opscode

metadata
cookbook 'mysql_connector', github: 'bflad/chef-mysql_connector', protocol: :https

group :integration do
  cookbook "apt"
  cookbook "java"
  cookbook "backup", path: '../backup'
end
