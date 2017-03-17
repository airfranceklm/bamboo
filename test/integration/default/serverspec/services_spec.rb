require 'spec_helper'

# Check if all services are running
services = if os[:family] == 'redhat'
             %w(postgresql httpd bamboo)
           else
             %w(postgresql apache2 bamboo)
           end

services.each do |service|
  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end

# Ports: postgres, apache, bamboo
ports = [5432, 80, 8085]

ports.each do |port|
  describe port(port) do
    it { should be_listening }
  end
end
