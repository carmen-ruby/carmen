require 'yaml'

require 'carmen/region_collection'
require 'carmen/utils'

module Carmen
  class Region

    attr_reader :type
    attr_reader :code
    attr_reader :parent

    def initialize(data={}, parent=nil)
      @type = data['type']
      @code = data['code']
      @parent = parent
    end

    def name
      Carmen.i18n_backend.translate(path('name'))
    end

    def subregions
      @subregions ||= load_subregions.freeze
    end

    def subregions?
      !subregions.empty?
    end

    def subregion_data_path
      @parent.subregion_data_path.sub('.yml', "/#{subregion_directory}.yml")
    end

    def subregion_class
      Region
    end

    # Return a path string for this region. Useful for use with I18n.
    #
    # Returns a string in the format "world.$PARENT_CODE.$REGION_CODE", such as
    # "world.us.il". The number of segments is the depth of the region plus one.
    def path(suffix=nil)
      base = "#{parent.path}.#{subregion_directory}"
      base << ".#{suffix.to_s}" if suffix
      base
    end

    def inspect
      "<##{self.class} name=\"#{name}\" type=\"#{type}\">"
    end

    def to_s
      name
    end

    def to_hash
      { type: type, code: code, name: name, subregions: subregions }
    end

    # Clears the subregion cache
    def reset!
      @subregions = nil
    end

    def <=>(other)
      name <=> other.name
    end

  private

    def subregion_directory
      code.downcase
    end

    def load_subregions
      if Carmen.data_paths.any? {|path| (path + subregion_data_path).exist? }
        load_subregions_from_path(subregion_data_path, self)
      else
        RegionCollection.new([])
      end
    end

    def load_subregions_from_path(path, parent=nil)
      regions = load_data_at_path(path).collect do |data|
        subregion_class.new(data, parent)
      end
      RegionCollection.new(regions)
    end

    # Load the data for a path.
    #
    # The resulting data will be the result of loading the file from the data_path
    # and overlaying matching data (if it exists) from the overlay_path.
    def load_data_at_path(path)
      data_sets = Carmen.data_paths.map do |data_path|
        if File.exist?(data_path + path)
          YAML.load_file(data_path + path)
        else
          []
        end
      end
      flatten_data(data_sets)
    end

    # Merge multiple arrays of hashes together
    #
    # Use either 'code' or 'alpha_2_code' to match elements between the sets.
    #
    # Returns a single merged array of hashes.
    def flatten_data(arrays)
      keys = %w(code alpha_2_code)
      Utils.merge_arrays_by_keys(arrays, keys).reject do |hash|
        hash['_enabled'] == false
      end
    end
  end
end
