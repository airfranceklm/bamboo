

remote_file "/opt/atlassian-bamboo-agent-installer.jar" do
  source "#{node['bamboo']['url']}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-#{node['bamboo']['version']}.jar"
  mode "0644"
  not_if { ::File.exists?("/opt/atlassian-bamboo-agent-installer.jar") }
end

execute "java -Dbamboo.home=/opt/bamboo -jar /opt/atlassian-bamboo-agent-installer.jar #{node['bamboo']['url']}/agentServer/ install" do
  not_if { ::File.exists?("/opt/bamboo/.installed") }
end

file "/opt/bamboo/.installed" do
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
end

link "/etc/init.d/bamboo-agent" do
  to "/opt/bamboo/bin/bamboo-agent.sh"
end

service "bamboo-agent" do
  supports :restart => true, :status => true, :start => true, :stop => true
  action [:enable, :start]
end