require 'spec_helper'

packages = case
           when os[:family] == 'ubuntu' &&  os[:release] == '12.04'
             then ['mysql-server-5.5', 'apache2']
           when os[:family] == 'ubuntu' &&  os[:release] == '14.04'
             then ['mysql-server-5.6', 'apache2']
           when os[:family] == 'redhat'
             then ['mysql-community-client', 'mysql-community-server', 'httpd']
           end

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end


