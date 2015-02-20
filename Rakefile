begin
  require 'rspec/core/rake_task'
  require 'parallel_tests/tasks'
  RSpec::Core::RakeTask.new(:spec)
  task :test => 'parallel:spec'
  task :default => :test
rescue LoadError
end