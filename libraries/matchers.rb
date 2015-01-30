if defined?(ChefSpec)
  def add_bamboo_agent_capability(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:bamboo_agent_capability, :add, resource_name)
  end

  def remove_bamboo_agent_capability(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:bamboo_agent_capability, :remove, resource_name)
  end
end
