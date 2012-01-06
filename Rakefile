require 'rubygems'
require 'rake'
require 'hanna/rdoctask'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

desc 'Generate RDoc documentation for the carmen plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_files.include('README.rdoc', 'MIT-LICENSE').
    include('lib/**/*.rb')

  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "carmen documentation"

  rdoc.rdoc_dir = 'doc' # rdoc output folder
  rdoc.options << '--webcvs=http://github.com/jim/carmen/tree/master/'
end
