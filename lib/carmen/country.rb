require 'forwardable'

require 'carmen/world'
require 'carmen/region'
require 'carmen/querying'

module Carmen
  class Country < Region
    extend Querying
    extend SingleForwardable

    attr_reader :alpha_2_code
    attr_reader :alpha_3_code
    attr_reader :numeric_code

    def initialize(data={}, parent=nil)
      @alpha_2_code = data['alpha_2_code']
      @alpha_3_code = data['alpha_3_code']
      @numeric_code = data['numeric_code']
      super
    end

    def common_name
      Carmen.i18n_backend.translate(path('common_name'))
    end

    def official_name
      Carmen.i18n_backend.translate(path('official_name'))
    end

    def self.all
      World.instance.subregions
    end

    def self.query_collection
      all
    end

    class << self
      %w(numeric alpha_2 alpha_3).each do |attr|
        define_method "#{attr}_coded" do |code|
          code = code.to_s.downcase
          query_collection.find do |region|
            region.send("#{attr}_code").downcase == code
          end
        end
      end
      alias_method :numerically_coded, :numeric_coded
    end

    def inspect
      %(<##{self.class} name="#{name}">)
    end

    def code
      alpha_2_code
    end

    def to_hash
      super.merge({ alpha_2_code: alpha_2_code, alpha_3_code: alpha_3_code, numeric_code: numeric_code })
    end

  private

    def self.attribute_to_search_for_code(code)
      if code.to_s.size == 2
        :alpha_2_code
      elsif code =~ /\d{3}/
        :numeric_code
      else
        :alpha_3_code
      end
    end

    def subregion_directory
      alpha_2_code.downcase
    end

  end
end
