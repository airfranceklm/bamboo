require 'spec_helper'

# Check if all services are running
services = %w(mysql-default apache2 bamboo)

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
