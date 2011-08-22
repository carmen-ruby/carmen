require 'yaml'

require 'carmen/region_collection'

module Carmen
  # A Region is the basic geographic object used throughout the
  # library. It is responsible for querying its subregions.
  class Region

    attr_reader :type
    attr_reader :name
    attr_reader :code
    attr_reader :parent

    def initialize(type, name, code, parent=nil)
      @type = type
      @name = name
      @code = code
      @parent = parent
    end

    def subregions
      @subregions ||= load_subregions
    end

    def self.load_from_file(path)
      regions = YAML.load_file(path).map do |data|
        self.new(:region, *data)
      end

      RegionCollection.new(regions)
    end

    private

    def subregion_data_path
      if @parent
        @parent.subregion_data_path.gsub('.yml', "/#{code}.yml")
      else
        Carmen::data_path + 'world.yml'
      end
    end

    def subregions?
      File.exist?(subregion_data_path)
    end

    def load_subregions
      if subregions?
        self.class.load_from_file(subregion_data_path)
      end
    end
  end
end
