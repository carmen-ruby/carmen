require 'singleton'
require 'carmen/region'

module Carmen
  class World < Region
    include Singleton

    def type; 'world'; end
    def name; 'Earth'; end

    def subregion_data_path
      'world.yml'
    end

    def subregion_class
      Country
    end

    def continents
      Continent.world.sub_continents
    end

    def countries
      Continent.world.countries
    end

    def path
      'world'
    end

    def inspect
      "<##{self.class}>"
    end

  end
end
