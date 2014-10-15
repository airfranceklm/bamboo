use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :add do
  node.set['bamboo']['agent_capabilities'][new_resource.name] = new_resource.value
end

action :remove do
  node.set['bamboo']['agent_capabilites'].delete(new_resource.name)
end
