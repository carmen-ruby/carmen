require 'minitest/unit'
require 'minitest/spec'
require 'minitest/autorun'

require 'bundler/setup'
require 'carmen'

def setup_carmen_test_data_path
  Carmen.clear_data_paths
  Carmen.append_data_path(File.expand_path('../data', __FILE__))
end

def setup_carmen_test_i18n_backend
  locale_path = File.expand_path('../locale', __FILE__)
  Carmen.i18n_backend = Carmen::I18n::Simple.new(locale_path)
end

setup_carmen_test_data_path
setup_carmen_test_i18n_backend

