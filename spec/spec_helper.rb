require 'minitest/spec'
require 'minitest/autorun'

lib_path = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_path)

require 'carmen'

Carmen.data_path = File.expand_path('../data', __FILE__)
