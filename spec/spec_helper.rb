require 'minitest/spec'
require 'minitest/autorun'

lib_path = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_path)

require 'carmen'

Carmen.data_path = File.expand_path('../data', __FILE__)

locale_path = File.expand_path('../locale', __FILE__)
Carmen.i18n_backend = Carmen::I18n::Simple.new(locale_path)
