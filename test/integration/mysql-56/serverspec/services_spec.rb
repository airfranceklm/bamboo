require 'spec_helper'

# Check if all services are running
services = if os[:family] == 'redhat'
             # mysqld doesn't seem to be running as a service.  This should be
             # fine since I would assume most people are going to run mysql off
             # site on a external server.
             %w(httpd bamboo)
           else
             %w(mysql-db1 apache2 bamboo)
           end

services.each do |service|
  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end

# Ports: mysql, apache, bamboo
ports = [3306, 80, 8085]

ports.each do |port|
  describe port(port) do
    it { should be_listening }
  end
end
