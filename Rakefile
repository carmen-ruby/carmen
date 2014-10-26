require 'rubygems'
require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:spec) do |test|
  test.libs << 'lib' << 'spec'
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = true
end

task :default => :spec

desc "Start a console with this version of Carmen loaded"
task :console do
  require 'bundler/setup'
  require 'carmen'
  require 'irb'
  ARGV.clear
  IRB.start
end
