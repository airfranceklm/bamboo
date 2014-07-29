source "https://api.berkshelf.com"

metadata
cookbook 'backup', git: 'https://github.com/damm/backup'
cookbook 'apache2', git: 'https://github.com/onehealth-cookbooks/apache2.git', branch: 'COOK-3900'

group :integration do
  cookbook "apt"
  cookbook "java"
end
