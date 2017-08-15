require 'rspec/core/rake_task'

task :default => [:spec]

desc "Run the specs."
RSpec::Core::RakeTask.new(:spec)

desc "Run the specs whenever a relevant file changes."
task :watch do
  system "bundle exec guard"
end
