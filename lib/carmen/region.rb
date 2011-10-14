require 'yaml'

require 'carmen/region_collection'

module Carmen
  # A Region is the basic geographic object used throughout the
  # library. It is responsible for querying its subregions.
  class Region

    attr_reader :type
    attr_reader :name
    attr_reader :alpha_2_code
    attr_reader :alpha_3_code
    attr_reader :parent

    def initialize(data={})
      @type = data['type']
      @name = data['name']
      @alpha_2_code = data['alpha_2_code']
      @alpha_3_code = data['alpha_3_code']
      @parent = data['parent']
    end

    def subregions
      @subregions ||= load_subregions
    end

    def self.load_from_file(path, parent=nil)
      regions = YAML.load_file(path).map do |data|
        self.new(data.merge('parent' => parent))
      end

      RegionCollection.new(regions)
    end

    def subregion_data_path
      if @parent
        path = @parent.subregion_data_path.dirname + "regions/#{alpha_2_code.downcase}.yml"
        Pathname.new(path)
      else
        Carmen::data_path + 'world.yml'
      end
    end

    def subregions?
      File.exist?(subregion_data_path)
    end

    def inspect
      "<##{self.class} type=#{type} subregions?=#{subregions?}>"
    end

  private

    def load_subregions
      if subregions?
        self.class.load_from_file(subregion_data_path, self)
      end
    end
  end
end
