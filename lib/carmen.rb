require 'yaml'
require 'pathname'

lib_path = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_path)

require 'carmen/country'

module Carmen
  class << self
    attr_accessor :data_path
  end

  self.data_path = Pathname.new(File.expand_path('../../iso_data', __FILE__))
end
