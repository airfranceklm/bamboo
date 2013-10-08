name              "bamboo"
maintainer        "CC WD eDEn."
maintainer_email  "ramon.makkelie@klm.com"
license           "Apache 2.0"
description       "Installs and configures ceph for OpenStack"
version           "1.0.1"

recipe "bamboo", "Installs and configures bamboo"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ apache2 cron database git java mysql mysql_connector perl ark java }.each do |cb|
  depends cb
end