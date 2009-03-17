require 'yaml'
require 'ftools'

module Carmen
  
  data_path = File.join(File.dirname(__FILE__), '../data')
  
  COUNTRIES = YAML.load_file(File.join(data_path, 'countries.yml'))
  
  states = Dir[data_path + '/states/*'].map do |file_name|
    [File::basename(file_name, '.yml').upcase, YAML.load_file(file_name)]
  end
  
  STATES = states

  def self.country_name(code_to_find)
    search_collection(COUNTRIES, code_to_find, 1, 0)
  end
  
  def self.country_code(name_to_find)
    search_collection(COUNTRIES, name_to_find, 0, 1)
  end

  def self.state_name(code_to_find, country = 'US')
    state = search_collection(STATES, country, 0, 1)
    search_collection(state, code_to_find, 1, 0)
  end
  
  def self.state_code(name_to_find, country = 'US')
    state = search_collection(STATES, country, 0, 1)
    search_collection(state, name_to_find, 0, 1)
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