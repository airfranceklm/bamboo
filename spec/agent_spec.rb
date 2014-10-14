require 'spec_helper'

describe 'debian::bamboo::agent' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(
                                   platform: 'debian',
                                   version: '7.4',
                                   step_into: ['bamboo_agent_capability']
                                 ) do |node|
      node.automatic['memory']['total'] = '2048kB'
      node.automatic['ipaddress'] = '1.1.1.1'
    end
    runner.converge('bamboo::_unit_testing_agent_capability')
  end

  it 'template[bamboo-capabilities.properties]' do
    expect(chef_run).to create_template('bamboo-capabilities.properties')
    expect(chef_run).to render_file('bamboo-capabilities.properties')
      .with_content(/system.of.a.down/)
  end
end
