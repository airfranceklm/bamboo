module Bamboo
  # Bamboo::Helpers module
  module Helpers
    def bamboo_virtual_host_name
      node['bamboo']['apache2']['virtual_host_name'] || node['fqdn'] || node['machinename'] || node['hostname']
    end

    def bamboo_virtual_host_alias
      node['bamboo']['apache2']['virtual_host_alias'] || node['hostname']
    end

    def bamboo_database_connection
      settings = merge_bamboo_settings

      database_connection = {        
        host: settings['database']['host'],
        port: settings['database']['port']
      }

      case settings['database']['type']
      when 'mysql'
        database_connection[:username] = 'root'
        database_connection[:password] = node['mysql']['server_root_password']
      when 'postgresql'
        database_connection[:username] = 'postgres'
        database_connection[:password] = node['postgresql']['password']['postgres']
      end

      database_connection
    end

    # Merges Bamboo settings from data bag and node attributes.
    # Data dag settings always has a higher priority.
    #
    # @return [Hash] Settings hash
    def merge_bamboo_settings
      @settings_from_data_bag ||= settings_from_data_bag
      settings = Chef::Mixin::DeepMerge.deep_merge(
        @settings_from_data_bag,
        node['bamboo'].to_hash
      )

      case settings['database']['type']
      when 'mysql'
        settings['database']['port'] ||= 3306
      when 'postgresql'
        settings['database']['port'] ||= 5432
      when 'hsqldb'
        # No-op. HSQLDB doesn't require any configuration.
      else
        raise "Unsupported database type: #{settings['database']['type']}"
      end

      settings
    end

    # Fetchs Confluence settings from the data bag
    #
    # @return [Hash] Settings hash
    def settings_from_data_bag
      begin
        item = data_bag_item(node['bamboo']['data_bag_name'],
                             node['bamboo']['data_bag_item'])['bamboo']
        return item if item.is_a?(Hash)
      rescue
        Chef::Log.info('No bamboo data bag found')
      end
      {}
    end

    # Returns download URL for Bamboo artifact
    def bamboo_artifact_url
      return node['bamboo']['download_url'] unless node['bamboo']['download_url'].nil?

      version = node['bamboo']['version']

      "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-#{version}.tar.gz"
    end

    # Returns SHA256 checksum of specific Bamboo artifact
    def bamboo_artifact_checksum
      return node['bamboo']['checksum'] unless node['bamboo']['checksum'].nil?

      version = node['bamboo']['version']
      sums = bamboo_checksum_map[version]

      raise "Bamboo version #{version} is not supported by the cookbook" unless sums
    end

    # Returns SHA256 checksum map for Bamboo artifacts
    def bamboo_checksum_map
      {
        '5.10.3' => 'da6326d49dd5234319518f4b55fdfe521918931971c48bd43a48d6f6fb2717a6',
        '5.12.4' => '9d1b6bf54db4bbc8e62c7197f875ff2509a9c4074871ccd3574641001583bb14',
        '5.12.5' => '2b598b71adbffb67627e1a9fe0c182e4ce8f7e6e3f3e63c0d83ea146b13c4d12',
        '5.13.1' => '59fc8c585199e0051c6f63fc6e1cb4e56c05e29ba6b66507618bf554dc81fac3',
        '5.13.2' => '02e7fa07f5955e62327c2bec6b8850807f164aeffe30741d2073a5e422a6f1b6',
        '5.14.1' => '2c758729c8d144dbaa1273ae5e6d7f955c9c195f69ee819e995e9394f72325f4'
      }
    end

    # symlink check for cookbook users <= 1.7.0
    def file_dir_or_symlink_exists?(path_to_file)
      File.exist?(path_to_file) || File.symlink?(path_to_file)
    end

  end
end

::Chef::Recipe.send(:include, Bamboo::Helpers)
::Chef::Resource.send(:include, Bamboo::Helpers)
::Chef::Mixin::Template::TemplateContext.send(:include, Bamboo::Helpers)
