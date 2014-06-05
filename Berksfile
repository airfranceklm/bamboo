source "https://api.berkshelf.com"

metadata
cookbook 'backup', git: 'https://github.com/damm/backup'
cookbook 'mysql_connector', git: 'https://github.com/bflad/chef-mysql_connector'

group :integration do
  cookbook "apt"
  cookbook "java"
end
