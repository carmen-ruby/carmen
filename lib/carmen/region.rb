require 'yaml'
require 'pathname'

require 'carmen/region_collection'

module Carmen
  class Region

    attr_reader :type
    attr_reader :name
    attr_reader :code
    attr_reader :parent

    def initialize(data={}, parent=nil)
      @type = data['type']
      @name = data['name']
      @code = data['code']
      @parent = parent
    end

    def subregions
      @subregions ||= load_subregions
    end

    def subregions?
      !subregions.empty?
    end

    def subregion_data_path
      path = @parent.subregion_data_path.sub('.yml', "/#{subregion_directory}.yml")
      Pathname.new(path)
    end

    def subregion_class
      Region
    end

    def inspect
      "<##{self.class} name=\"#{name}\" type=\"#{type}\">"
    end

    # Clears the subregion cache
    def reset!
      @subregions = nil
    end

  private

    def subregion_directory
      code.downcase
    end

    def load_subregions
      if File.exist?(subregion_data_path)
        load_subregions_from_file(subregion_data_path, self)
      else
        []
      end
    end

    def load_subregions_from_file(path, parent=nil)
      regions = YAML.load_file(path).map do |data|
        subregion_class.new(data, parent)
      end

      RegionCollection.new(regions)
    end
  end
end
