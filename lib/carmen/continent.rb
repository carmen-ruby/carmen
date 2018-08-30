require 'yaml'
require 'carmen/country'

module Carmen
  class Continent
    attr_reader :code

    def initialize(data={})
      @code = data['territory']
      @contains = data['contains']
    end

    def name
      Carmen.i18n_backend.translate("continents.#{self.code}.name")
    end

    def sub_continents
      contained_continents_or_countries.select { |continent_or_country| continent_or_country.is_a? Continent }
    end

    def countries
      if sub_continents.any?
        sub_continents.map { |c| c.countries }.flatten
      else
        contained_continents_or_countries.select { |continent_or_country| continent_or_country.is_a? Country }
      end      
    end

    def continent
      Carmen::Continent.all.detect { |c| c.sub_continents.include?(self) }
    end

    def self.coded(code)
      Continent.all.detect { |c| c.code == code }
    end

    def self.all
      continents.reject { |c| c.world? }
    end

    def self.world
      continents.select { |c| c.world? }.first
    end

    def world?
      code == "001"
    end

    private 

    def contained_continents_or_countries
      if @contains.present?
        @contains.map { |c| code_to_object(c) } 
      else
        []
      end
    end

    def code_to_object(code)
      if /\d\d\d/.match(code) 
        Continent.coded(code)
      elsif /[A-Z][A-Z]/.match(code)
        Country.coded(code)
      end
    end

    def self.continents
      @continents ||= load_territory_containment["territoryContainment"].map { |tc| Continent.new(tc) }
    end

    def self.load_territory_containment
      YAML.load_file(Carmen.territories_path)
    end

  end
end