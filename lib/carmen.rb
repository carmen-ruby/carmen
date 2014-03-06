require 'yaml'
require 'pathname'

lib_path = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_path)

require 'carmen/country'
require 'carmen/i18n'
require 'carmen/version'

module Carmen
  class << self

    attr_accessor :data_paths, :i18n_backend

    # Public: Return the current array of locations where data files are stored.
    #
    # Data in entries that appear later in the array takes precedence.
    #
    # Each path should follow the following structure:
    # |- world.yml (all countries)
    # \- regions   (directory for subregions, named by code)
    #  |- be.yml   (subregion file for a country)
    #
    # Defaults to only the the `iso_data` directory within the Carmen directory.
    def data_paths
      @data_paths
    end

    # Public: Set the array of paths for Carmen to search for data files.
    def data_paths=(paths)
      @data_paths = paths
    end

    # Public: return the current I18n backend.
    #
    # Defaults to an instance of Carmen::I18n::Simple.
    def i18n_backend
      @i18n_backend
    end

    # Public: set an object to use as the I18n backend.
    #
    # Ths suppiled object must respond to t(key).
    def i18n_backend=(backend)
      @i18n_backend = backend
    end

    # Public: the Carmen library's root directory.
    #
    # Provides a way to find the built-in data and locale files.
    attr_accessor :root_path

    # Public: Append an additional data path.
    # path - The String path to the data directory.
    def append_data_path(path)
      World.instance.reset!
      self.data_paths << Pathname.new(path)
    end

    # Public: Clear the data_paths array.
    def clear_data_paths
      World.instance.reset!
      self.data_paths = []
    end

    # Public: Reset the data_paths array to the defaults.
    def reset_data_paths
      clear_data_paths
      append_data_path(root_path + 'iso_data/base')
      append_data_path(root_path + 'iso_data/overlay')
    end

    # Public: Reset the i18n_backend to a default backend.
    def reset_i18n_backend
      base_locale_path = root_path + 'locale/base'
      override_locale_path = root_path + 'locale/overlay'
      self.i18n_backend = Carmen::I18n::Simple.new(base_locale_path,
                                                   override_locale_path)
    end
  end

  self.root_path = Pathname.new(__FILE__) + '../..'

  self.reset_data_paths
  self.reset_i18n_backend

end
