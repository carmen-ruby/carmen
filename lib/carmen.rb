require 'yaml'
require 'pathname'

lib_path = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_path)

require 'carmen/country'
require 'carmen/i18n'
require 'carmen/version'

module Carmen
  class << self

    # Public: An array of locations where data files for Carmen are stored.
    #
    # Data in entries that appear later in the array takes precedence.
    #
    # Each path should follow the following structure:
    # |- world.yml (all countries)
    # \- regions   (directory for subregions, named by code)
    #  |- be.yml   (subregion file for a country)
    #
    # Defaults to only the the `iso_data` directory within the Carmen directory.
    attr_reader :data_paths

    # Public: an object to use as the I18n backend.
    #
    # Ths suppiled object must respond to
    # t(key).
    #
    # Defaults to an instance of Carmen::I18n::Simple.
    attr_accessor :i18n_backend

    # Private: the Carmen library's root directory.
    #
    # Provides a way to find the built-in data and locale files.
    attr_accessor :root_path

    # Public: Set the data path.
    # path - The String path to the data directory.
    def append_data_path(path)
      World.instance.reset!
      @data_paths << Pathname.new(path)
    end

    # Public: Clear the data_paths array.
    # path - The String path to the data directory.
    def clear_data_paths
      World.instance.reset!
      @data_paths = []
    end

    # Public: Reset the data_paths array to the defaults.
    def reset_data_paths
      clear_data_paths
      append_data_path(root_path + 'iso_data')
    end

    def reset_i18n_backend
      locale_path = root_path + 'locale'
      self.i18n_backend = Carmen::I18n::Simple.new(locale_path)
    end
  end

  self.root_path = Pathname.new(__FILE__) + '../..'

  self.reset_data_paths
  self.reset_i18n_backend

end
