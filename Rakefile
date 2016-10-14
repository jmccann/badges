require 'fileutils'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# describes the unit tests
# unit tests must in the 'spec' folder have a '_unit' in them
namespace :unit do
  RSpec::Core::RakeTask.new
end

# describes the style tests
# style tests make use of a tool called rubocop
namespace :style do
  desc 'Run Ruby style checks'
  task :ruby do
    sh 'rubocop'
  end
end

# Default task when running 'rake' will execute the following tasks, in order:
# unit tests, functional tests, and style checking
task default: %w(unit:spec style:ruby)
