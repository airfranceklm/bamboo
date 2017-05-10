require 'spec_helper'

packages = case
           when os[:family] == 'ubuntu' &&  os[:release] == '14.04'
             then ['postgresql-9.4', 'apache2']
           when os[:family] == 'redhat'
             then ['postgresql', 'postgresql-server', 'httpd']
           end

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end


