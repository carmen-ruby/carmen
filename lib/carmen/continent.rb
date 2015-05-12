require 'carmen/country'

module Carmen
  class Continent

    attr_reader :code
    attr_reader :parent

    def initialize(data={}, parent=nil)
      @code = data['territory']
      @contains = data['contains'].split(' ')
      @parent = parent
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

    def self.coded(code)
      Continent.all.detect { |c| c.code == code }
    end

    def self.all
      continents
    end

    def world?
      code == "001"
    end

    private 

    def contained_continents_or_countries
      @contains.map { |c| code_to_object(c) }
    end

    def code_to_object(code)
      if /\d\d\d/.match(code) 
        Continent.coded(code)
      elsif /[A-Z][A-Z]/.match(code)
        Country.coded(code)
      end
    end

    def self.continents
      @continents ||= load_territory_containment.map { |tc| Continent.new(tc) }
    end

    def self.load_territory_containment
      JSON.parse(File.read(Carmen.territories_path))["territoryContainment"]
    end

  end
end