require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/dsl_definition'

namespace :style do
  desc 'Run RuboCop style and lint checks'
  RuboCop::RakeTask.new(:rubocop)

  desc 'Run Foodcritic lint checks'
  FoodCritic::Rake::LintTask.new(:foodcritic)
end

desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

namespace :integration do
  desc 'Run Test Kitchen with cloud'
  task :cloud do
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end
end

desc 'Run all style checks'
task style: ['style:rubocop', 'style:foodcritic']

# Default
task default: [:style, :spec]

# Full integration testing
task full: [:style, 'integration:cloud']
