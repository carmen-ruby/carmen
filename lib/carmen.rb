require 'yaml'
require 'pathname'

lib_path = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib_path)

require 'carmen/country'

module Carmen
  class << self

    # Public: Where the data files for Carmen are stored.
    #
    # Should be in the following format:
    # |- world.yml (all countries)
    # \- regions   (directory for subregions, named by code)
    #  |- be.yml   (subregion file for a country)
    #
    # Defaults to the `iso_data` directory within the Carmen directory.
    attr_reader :data_path

    # Public: Where to store overlay data.
    #
    # Overlay data is loaded after the data in `data_path`. Entries that appear
    # within the `overlay_path` take precedence.
    #
    # The files in this directory should be in an identical layout to those in
    # `data_path`. There should only be a file in the overlay directory if the
    # corresponding regoins has overlay data. Only the regions to be modified
    # should be included in an overlay file.
    #
    # Defaults to nil (no overlay data).
    attr_reader :overlay_path

    # Public: Set the data path.
    # path - The String path to the data directory.
    def data_path=(path)
      raise "Carmen's data_path cannot be nil" if path.nil?
      @data_path = Pathname.new(path)
      World.instance.reset!
    end

    # Public: Set the overlay data path.
    # path - The String path to the overlay data directory.
    def overlay_path=(path)
      path = Pathname.new(path) unless path.nil?
      @overlay_path = path
      World.instance.reset!
    end
  end

  self.data_path = File.expand_path('../../iso_data', __FILE__)
end
