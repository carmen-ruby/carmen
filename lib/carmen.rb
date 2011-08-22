require 'yaml'
require 'pathname'

lib_path = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_path)

# What are we using ftools for?
begin
  require 'ftools'
rescue LoadError
  require 'fileutils' # ftools is now fileutils in Ruby 1.9
end

require 'carmen/country'

module Carmen
  class << self
    attr_accessor :data_path
  end

  self.data_path = Pathname.new(File.expand_path('../../data', __FILE__))
end
