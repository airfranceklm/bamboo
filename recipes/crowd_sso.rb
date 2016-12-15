# Update config to activate Crowd's authenticator to enable SSO
# See: https://confluence.atlassian.com/crowd/integrating-crowd-with-atlassian-bamboo-198785.html

template "#{node['bamboo']['home_dir']}/atlassian-bamboo/WEB-INF/classes/crowd.properties" do
  source 'crowd.properties.erb'
  owner node['bamboo']['user']
  group node['bamboo']['user']
  mode '0644'
  action :create
  variables(
    app_name: settings['crowd_sso']['app_name'],
    app_password: settings['crowd_sso']['app_password'],
    crowd_base_url: settings['crowd_sso']['crowd_base_url']
  )
  sensitive true
  notifies :restart, 'service[bamboo]', :delayed
end

default_fragment = '<authenticator class="com.atlassian.bamboo.user.authentication.BambooAuthenticator"/>'
sso_fragment = '<authenticator class="com.atlassian.crowd.integration.seraph.v25.BambooAuthenticator"/>'

ruby_block 'Set Crowd authenticator' do
  block do
    fe = Chef::Util::FileEdit.new("#{node['bamboo']['home_dir']}/atlassian-bamboo/WEB-INF/classes/seraph-config.xml")
    fe.search_file_replace(/#{Regexp.quote(default_fragment)}/, sso_fragment)
    fe.write_file
  end
  only_if %(grep '#{default_fragment}' \
    #{node['bamboo']['home_dir']}/atlassian-bamboo/WEB-INF/classes/seraph-config.xml)
  notifies :restart, 'service[bamboo]', :delayed
end
