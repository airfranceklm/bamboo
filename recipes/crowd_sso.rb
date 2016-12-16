# Update config to activate Crowd's authenticator to enable SSO
# See: https://confluence.atlassian.com/crowd/integrating-crowd-with-atlassian-bamboo-198785.html

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
