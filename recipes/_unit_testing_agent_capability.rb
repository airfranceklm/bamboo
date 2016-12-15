bamboo_agent_capability 'system.git.executable' do
  value '/usr/local/bin/git'
end

bamboo_agent_capability 'system.of.a.down' do
  value 'Toxicity'
end

template 'bamboo-capabilities.properties' do
  path "#{node['bamboo']['agent']['data_dir']}/bin/bamboo-capabilities.properties"
  source 'bamboo-capabilities.properties.erb'
  owner  node['bamboo']['agent']['user']
  group  node['bamboo']['agent']['group']
  mode '0644'
  variables(
    :options => node['bamboo']['agent_capabilities']
  )
end
