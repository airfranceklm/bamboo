require 'spec_helper'

packages = ['mysql-server-5.6', 'apache2']

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end


