require 'minitest/unit'
require 'minitest/spec'
require 'minitest/autorun'

require 'bundler/setup'
require 'carmen'

def setup_carmen_test_data_path
  Carmen.clear_data_paths
  Carmen.append_data_path(carmen_spec_data_path)
end

def setup_carmen_test_i18n_backend
  Carmen.i18n_backend = Carmen::I18n::Simple.new(carmen_spec_locale_path)
end

def carmen_spec_data_path
  Carmen.root_path + 'spec_data/data'
end

def carmen_spec_locale_path
  Carmen.root_path + 'spec_data/locale'
end

def carmen_spec_overlay_locale_path
  Carmen.root_path + 'spec_data/overlay/locale'
end

def carmen_spec_overlay_data_path
  Carmen.root_path + 'spec_data/overlay/data'
end

setup_carmen_test_data_path
setup_carmen_test_i18n_backend

