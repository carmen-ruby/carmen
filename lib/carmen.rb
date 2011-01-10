require 'yaml'
begin
  require 'ftools'
rescue LoadError
  require 'fileutils' # ftools is now fileutils in Ruby 1.9
end

# Fix to autoload in Rails 3
if defined?(Rails) && Rails::VERSION::MAJOR > 2
  require 'carmen/railtie'
end

module Carmen

  class << self
    attr_accessor :default_country, :default_locale, :excluded_countries, :excluded_states
  end
  
  self.default_country = 'US'
  self.default_locale = :en
  self.excluded_countries = []
  self.excluded_states = {} 
  
  @data_path = File.join(File.dirname(__FILE__), '..', 'data')
  
  @states = Dir[File.join(@data_path, '/states/*.yml')].map do |file_name|
    [File.basename(file_name, '.yml').upcase, YAML.load_file(file_name)]
  end
  
  # Raised when attempting to retrieve states for an unsupported country
  class StatesNotSupported < RuntimeError; end

  # Raised when attempting to work with a country not in the data set
  class NonexistentCountry < RuntimeError; end
  
  # Raised when attemting to switch to a locale which does not exist
  class UnavailableLocale < RuntimeError; end
  
  # Returns a list of all countries
  def self.countries(options={})
    # Use specified locale or fall back to default locale
    locale = (options.delete(:locale) || @default_locale).to_s
    
    # Load the country list for the specified locale
    @countries ||= {}
    unless @countries[locale]
      # Check if data in the specified locale is available
      localized_data = File.join(@data_path, "countries", "#{locale}.yml")
      unless File.exists?(localized_data)
        raise(UnavailableLocale, "Could not load countries for '#{locale}' locale")
      end
      
      # As the data exists, load it
      @countries[locale] = YAML.load_file(localized_data)
    end
    
    # Return data after filtering excluded countries
    @countries[locale].reject { |c| excluded_countries.include?( c[1] ) }
  end

  
  # Returns the country name corresponding to the supplied country code, optionally using the specified locale.
  #  Carmen::country_name('TR') => 'Turkey'
  #  Carmen::country_name('TR', :locale => :de) => 'Türkei'
  def self.country_name(country_code, options={})
    search_collection(countries(options), country_code, 1, 0)
  end

  # Returns the country code corresponding to the supplied country name
  #  Carmen::country_code('Canada') => 'CA'
  def self.country_code(country_name, options={})
    search_collection(countries(options), country_name, 0, 1)
  end

  # Returns an array of all country codes
  #  Carmen::country_codes => ['AF', 'AX', 'AL', ... ]
  def self.country_codes
    countries.map {|c| c[1] }
  end
  
  # Returns an array of all country names, optionally using the specified locale.
  #  Carmen::country_names => ['Afghanistan', 'Aland Islands', 'Albania', ... ]
  #  Carmen::country_names(:locale => :de) => ['Afghanistan', 'Åland', 'Albanien', ... ]
  def self.country_names(options={})
    countries(options).map {|c| c[0] }
  end
  
  # Returns the state name corresponding to the supplied state code within the default country
  #  Carmen::state_code('New Hampshire') => 'NH'
  def self.state_name(state_code, country_code = Carmen.default_country, options={})
    search_collection(self.states(country_code, options), state_code, 1, 0)
  end

  # Returns the state code corresponding to the supplied state name within the specified country
  #  Carmen::state_code('IL', 'US') => Illinois
  def self.state_code(state_name, country_code = Carmen.default_country, options={})
    search_collection(self.states(country_code, options), state_name, 0, 1)
  end

  # Returns an array of state names within the default code
  #  Carmen::state_names('US') => ['Alabama', 'Arkansas', ... ]
  def self.state_names(country_code = Carmen.default_country, options={})
    self.states(country_code, options).map{|name, code| name}
  end

  # Returns an array of state codes within the specified country code
  #   Carmen::state_codes('US') => ['AL', 'AR', ... ]
  def self.state_codes(country_code = Carmen.default_country)
    self.states(country_code).map{|name, code| code}
  end

  # Returns an array structure of state names and codes within the specified country code, or within the default country
  # if none is provided.
  #   Carmen::states('US') => [['Alabama', 'AL'], ['Arkansas', 'AR'], ... ]
  #   Carmen::states => [['Alabama', 'AL'], ['Arkansas', 'AR'], ... ]
  def self.states(country_code = Carmen.default_country, options={})        
    raise NonexistentCountry.new("Country not found for code #{country_code}") unless country_codes.include?(country_code)
    raise StatesNotSupported unless states?(country_code)

    results = search_collection(@states, country_code, 0, 1)

    if excluded_states[country_code]
        results.reject { |s| excluded_states[country_code].include?(s[1]) }
    else
        results
    end
  end

  # Returns whether states are supported for the given country code
  #   Carmen::states?('US') => true
  #   Carmen::states?('ZZ') => false
  def self.states?(country_code, options={})
    @states.any? do |array| k,v = array
      k == country_code
    end
  end
  
  protected
  
  def self.search_collection(collection, value, index_to_match, index_to_retrieve)
    return nil if collection.nil?
    collection.each do |m|
      return m[index_to_retrieve] if m[index_to_match].downcase == value.downcase
    end
    # In case we didn't get any results we'll try a broader search (via Regexp)
    collection.each do |m|
      return m[index_to_retrieve] if m[index_to_match].downcase.match(value.downcase)
    end
    nil
  end
  
end
