require 'rubygems'
require 'rake'
require 'hanna/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "carmen"
    gem.summary = %Q{A collection of geographic country and state names for Ruby}
    gem.description = %Q{A collection of geographic country and state names for Ruby. Also includes replacements for Rails' country_select and state_select plugins}
    gem.email = "jim@autonomousmachine.com"
    gem.homepage = "http://github.com/jim/carmen"
    gem.authors = ["Jim Benton"]
    gem.add_development_dependency "mocha"
    gem.add_development_dependency "rails"
    gem.add_development_dependency "hanna"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

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
