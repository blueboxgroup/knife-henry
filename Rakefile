require 'rspec/core/rake_task'
require 'rubygems'
require_relative 'lib/knife-henry/info'

GEM_NAME = 'knife-henry'

task :default => :test

task :install do
  sh %{gem build #{GEM_NAME}.gemspec}
  sh %{gem install #{GEM_NAME}-#{KnifeHenry.version}.gem --no-ri --no-rdoc}
end

task :uninstall do
  sh %{gem uninstall #{GEM_NAME} -x}
end

task :reset do
  Rake::Task[:uninstall].execute
  Rake::Task[:install].execute
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'lib/knife-henry'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
