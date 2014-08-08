require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/dsl_definition'

desc 'Run RuboCop style and lint checks'
RuboCop::RakeTask.new(:rubocop)

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = {
    tags: %w(~FC001 ),
    fail_tags: ['any'],
    # include_rules: '',
    context: true
  }
end

desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

desc 'Run all tests'
task :test => [:rubocop, :foodcritic, :spec]
task :default => :test

# begin
#   require "kitchen/rake_tasks"
#   Kitchen::RakeTasks.new
#
#   desc "Alias for kitchen:all"
#   task :integration => "kitchen:all"
#
#   task :test => :integration
# rescue LoadError
#   puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
# en
