user node[:bamboo][:user] do
  comment "Bamboo Service Account"
  #home    node['bamboo']['home_path']
  shell   "/bin/bash"
  supports :manage_home => true
  system  true
  action  :create
end

if (node[:bamboo][:external_data])
  directory "/mnt/data" do
    owner  "root"
    group  "root"
    mode "0775"
    action :create
  end
  mount "/mnt/data" do
    device "/dev/vdb1"
    fstype "ext4"
    action   [:mount, :enable]
  end
end

include_recipe "java"

remote_file "/opt/atlassian-bamboo-agent-installer.jar" do
  source "#{node[:bamboo][:url]}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-#{node[:bamboo][:version]}.jar"
  mode "0644"
  owner  node[:bamboo][:user]
  group  node[:bamboo][:group]
  not_if { ::File.exists?("/opt/atlassian-bamboo-agent-installer.jar") }
end

execute "java -Ddisable_agent_auto_capability_detection=true -Dbamboo.home=/mnt/data/bamboo -jar /opt/atlassian-bamboo-agent-installer.jar #{node[:bamboo][:url]}/agentServer/ install" do
  user  node[:bamboo][:user]
  group  node[:bamboo][:group]
  not_if { ::File.exists?("/mnt/data/bamboo/installer.properties") }
end

#file "/opt/bamboo/.installed" do
#  owner  node[:bamboo][:user]
#  group  node[:bamboo][:group]
#  mode "0755"
#  action :create_if_missing
#end

link "/etc/init.d/bamboo-agent" do
  to "/mnt/data/bamboo/bin/bamboo-agent.sh"
end

service "bamboo-agent" do
  supports :restart => true, :status => true, :start => true, :stop => true
  action [:enable, :start]
end

# needed for jasper reports and solve pdf and font problems
package "libstdc++5" do
  action :install
end

#TODO: enable monit
#package "monit" do
#  action :install
#end
#
#template 'procfile.monitrc' do
#  path "/etc/monit/conf.d/bamboo-agent.conf"
#  owner 'root'
#  group 'root'
#  mode '0644'
#end