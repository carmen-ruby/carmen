require 'yaml'
require 'pathname'
require 'json'

begin
  require 'ftools'
rescue LoadError
  require 'fileutils' # ftools is now fileutils in Ruby 1.9
end

def write_file(data, path)
  FileUtils.mkdir_p(File.dirname(path))
  File.open(path + '.yml', 'w') { |f| f.write data.to_yaml }
end

def write_data_to_path_as_yaml(data, path)
  data_keys = %w{alpha_2_code alpha_3_code numeric_code type}
  locale_keys = %w{common_name name official_name}

  locale_data = {}
  data.each do |element|
    locale = {}
    locale_keys.each do |key|
      locale[key] = element.delete(key) if element.key?(key)
    end
    parent_key = element['alpha_2_code'] || element['code']
    locale_data[parent_key.downcase] = locale
  end

  path_segments = "en/#{path}".split('/').reverse
  wrapped_locale_data = path_segments.inject(locale_data) { |hash, path|
    { path => hash }
  }

  write_file(data, 'iso_data/base/' + path)
  write_file(wrapped_locale_data, 'locale/base/en/' + path)
end

def write_regions_to_path_as_yaml(regions_data, path)
  regions_data.each do |subregion_data|
    subregions = subregion_data.delete('subregions')
    if subregions
      subregion_path = path + "/#{subregion_data['code'].downcase}"
      write_regions_to_path_as_yaml(subregions, subregion_path)
    end
  end
  write_data_to_path_as_yaml(regions_data, path)
end

puts "Deleting old YAML files"

FileUtils.rm_rf('iso_data/base/')
FileUtils.rm_rf('locale/base/')

puts "Downloading data"

data_path = Pathname.new(File.expand_path('../../iso_data/base', __FILE__))
tmp_path = data_path + 'tmp'

FileUtils.mkdir_p(tmp_path)

files = {
  'iso_3166.json' => 'https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git/plain/data/iso_3166-1.json',
  'iso_3166_2.json' => 'https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git/plain/data/iso_3166-2.json'
}

files.each_pair do |file, url|
  `cd #{tmp_path.to_s} && curl -o #{file} "#{url}"`
end

# countries
puts "Importing countries"

country_data_path = tmp_path + 'iso_3166.json'
countries_json = JSON.parse(File.read(country_data_path))['3166-1']

countries = []

countries_json.each do |country|
  print '.'
  countries << {
    'alpha_2_code'  => country['alpha_2'],
    'alpha_3_code'  => country['alpha_3'],
    'numeric_code'  => country['numeric'],
    'common_name'   => country['common_name'],
    'name'          => country['name'],
    'official_name' => country['official_name'],
    'type'          => 'country'
  }
end

puts

sorted_countries = countries.sort_by {|e| e['alpha_2_code'] }
write_data_to_path_as_yaml(sorted_countries, 'world')

# regions
puts "Importing regions"

region_data_path = tmp_path + 'iso_3166_2.json'
regions_json = JSON.parse(File.read(region_data_path))['3166-2']

warnings = []

# Group the regions by their country code
regions_json.group_by { |h| h['code'].split(/-| /)[0] }.each do |country_code, country_subregions|
  regions = []

  # Hash of { <parent_region_code>: [<list of subregions>], ... }
  # We keep track of each subregions parent region (if there are any)
  # For countries with regions that do not have subregions, this will be empty
  parent_subregions = {}

  country_subregions.each do |subregion|
    data = {
      'code' => subregion['code'].gsub(%r{^#{country_code}-}i, ''),
      'name' => subregion['name'],
      'type' => subregion['type'].downcase
    }

    if subregion['parent']
      parent = country_subregions.find do |r|
        r['code'].split(/-| /)[1] == subregion['parent']
      end
      if parent
        parent_code = parent['code'].split(/-| /)[1]
        parent_subregions[parent_code] ||= []
        parent_subregions[parent_code] << data
      else
        warnings << "warning, did not find parent '#{subregion['parent']}'"
        warnings << subregion
        warnings << ''
      end
    else
      regions << data
    end
  end

  # Add the list of subregions to each of the parent regions
  parent_subregions.each do |parent_code, array_of_subregions|
    regions.find { |region| region['code'] == parent_code }.merge!(
      { 'subregions' => array_of_subregions }
    )
  end

  sorted_regions = regions.sort_by {|e| e['code'] }
  write_regions_to_path_as_yaml(sorted_regions, "world/#{country_code.downcase}")
  print '.'
end

puts

unless warnings.empty?
  puts warnings.join("\n")
end

FileUtils.rm_rf(tmp_path)
