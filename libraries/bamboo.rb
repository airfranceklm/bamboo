# Cookbook Recipe class
class Chef::Recipe::Bamboo
  def self.settings(node)
    begin
      if Chef::Config[:solo]
        begin
          settings = Chef::DataBagItem.load('bamboo', 'bamboo')['local']
        rescue
          Chef::Log.info('No bamboo data bag found')
        end
      else
        begin
          settings = Chef::EncryptedDataBagItem.load('bamboo', 'bamboo')[node.chef_environment]
        rescue
          Chef::Log.info('No bamboo encrypted data bag found')
        end
      end
    ensure
      settings ||= node[:bamboo]
      settings[:database][:port] ||= default_database_port settings[:database][:type]
      settings[:database][:testInterval] ||= 2
    end

    settings
  end

  def default_database_port(type)
    case type
    when 'mysql'
      3306
    when 'postgresql'
      5432
    when 'sqlserver'
      1433
    else
      Chef::Log.warn("Unsupported database type (#{type}) in Stash cookbook.")
      Chef::Log.warn('Please add to Stash cookbook or hard set Stash database port.')
      nil
    end
  end
end
