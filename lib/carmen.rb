require 'yaml'
begin
  require 'ftools'
rescue LoadError
  require 'fileutils' # ftools is now fileutils in Ruby 1.9
end

module Carmen

  class << self
    attr_accessor :default_country
  end
  
  self.default_country = 'US'
  
  data_path = File.join(File.dirname(__FILE__), '../data')
  
  COUNTRIES = YAML.load_file(File.join(data_path, 'countries.yml'))
  
  STATES = Dir[data_path + '/states/*.yml'].map do |file_name|
    [File::basename(file_name, '.yml').upcase, YAML.load_file(file_name)]
  end

  # Raised when attempting to retrieve states for an unsupported country
  class StatesNotSupported < RuntimeError; end

  # Raised when attempting to work with a country not in the data set
  class NonexistantCountry < RuntimeError; end

  # Returns the country name corresponding to the supplied country code
  #  Carmen::country_name('TV') => 'Tuvalu'
  def self.country_name(country_code)
    search_collection(COUNTRIES, country_code, 1, 0)
  end

  # Returns the country code corresponding to the supplied country name
  #  Carmen::country_code('Canada') => 'CA'
  def self.country_code(country_name)
    search_collection(COUNTRIES, country_name, 0, 1)
  end

  # Returns an array of all country codes
  #  Carmen::country_codes => ['AF', 'AX', 'AL', ... ]
  def self.country_codes
    COUNTRIES.map {|c| c[1] }
  end
  
  # Returns an array of all country codes
  #  Carmen::country_name => ['Afghanistan', 'Aland Islands', 'Albania', ... ]
  def self.country_names
    COUNTRIES.map {|c| c[0] }
  end
  
  # Returns the state name corresponding to the supplied state code within the specified country
  #  Carmen::state_code('New Hampshire') => 'NH'
  def self.state_name(state_code, country_code = Carmen.default_country)
    search_collection(self.states(country_code), state_code, 1, 0)
  end

  # Returns the state code corresponding to the supplied state name within the specified country
  #  Carmen::state_code('IL', 'US') => Illinois
  def self.state_code(state_name, country_code = Carmen.default_country)
    search_collection(self.states(country_code), state_name, 0, 1)
  end

  # Returns an array of state names within the specified country code
  #  Carmen::state_names('US') => ['Alabama', 'Arkansas', ... ]
  def self.state_names(country_code = Carmen.default_country)
    self.states(country_code).map{|name, code| name}
  end

  # Returns an array of state codes within the specified country code
  #   Carmen::state_codes('US') => ['AL', 'AR', ... ]
  def self.state_codes(country_code = Carmen.default_country)
    self.states(country_code).map{|name, code| code}
  end

  # Returns an array structure of state names and codes within the specified country code
  #   Carmen::states('US') => [['Alabama', 'AL'], ['Arkansas', 'AR'], ... ]
  def self.states(country_code = Carmen.default_country)
    raise NonexistantCountry unless country_codes.include?(country_code)
    raise StatesNotSupported unless states?(country_code)
    search_collection(STATES, country_code, 0, 1)
  end

  # Returns whether states are supported for the given country code
  #   Carmen::states?('US') => true
  #   Carmen::states?('ZZ') => false
  def self.states?(country_code)
    STATES.any? do |array| k,v = array
      k == country_code
    end
  end
  
  protected
  
  def self.search_collection(collection, value, index_to_match, index_to_retrieve)
    return nil if collection.nil?
    collection.each do |m|
      return m[index_to_retrieve] if m[index_to_match] == value
    end
    nil
  end
  
end