name              "bamboo"
maintainer        "CC WD eDEn."
maintainer_email  "ramon.makkelie@klm.com"
license           "Apache 2.0"
description       "Installs and configures ceph for OpenStack"
version           "1.0"

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

%w{ ark }.each do |cb|
  depends cb
end