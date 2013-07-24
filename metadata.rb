name              "bamboo"
maintainer        "CC WD eDEn."
maintainer_email  "ramon.makkelie@klm.com"
license           "Apache 2.0"
description       "Installs and configures ceph for OpenStack"
version           "0.1"

recipe "bamboo", "Installs and configures bamboo"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ java }.each do |cb|
  depends cb
end

%w{ mysql }.each do |cb|
  depends cb
end