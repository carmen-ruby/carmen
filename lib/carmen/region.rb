require 'yaml'

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
      @parent.subregion_data_path.sub('.yml', "/#{subregion_directory}.yml")
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
      if File.exist?(Carmen.data_path + subregion_data_path)
        load_subregions_from_file(subregion_data_path, self)
      else
        []
      end
    end

    def load_subregions_from_file(path, parent=nil)
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
      default_data = YAML.load_file(Carmen.data_path + path)
      return default_data if Carmen.overlay_path.nil?
      
      overlay_data = YAML.load_file(Carmen.overlay_path + path)
      flatten_data(default_data, overlay_data)
    end

    # Merge two datasets together, using either 'code' or 'alpha_2_code' to
    # match elements between the sets.
    def flatten_data(base, supplimental)
      supplimental.each do |suppliment|
        # Find the matching element in the base array
        target = base.find do |e|
          (e['code'] && e['code'] == suppliment['code']) ||
          (e['alpha_2_code'] && e['alpha_2_code'] == suppliment['alpha_2_code'])
        end

        # If this is an additional element, add it to the array and move on
        if !target
          base << suppliment
          next
        end

        # Delete the element if _enabled is false, or merge in the new values
        if suppliment['_enabled'] == false
          base.delete(target)
        else
          target.merge!(suppliment)
        end
      end
      base
    end
  end
end
