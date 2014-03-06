require 'nokogiri'
require 'yaml'
require 'pathname'

YAML::ENGINE.yamler = 'psych'

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


puts "Downloading data"

data_path = Pathname.new(File.expand_path('../../iso_data/base', __FILE__))
tmp_path = data_path + 'tmp'

FileUtils.mkdir_p(tmp_path)

files = {
  'iso_3166.xml' => 'http://anonscm.debian.org/gitweb/?p=iso-codes/iso-codes.git;a=blob_plain;f=iso_3166/iso_3166.xml;hb=HEAD',
  'iso_3166_2.xml' => 'http://anonscm.debian.org/gitweb/?p=iso-codes/iso-codes.git;a=blob_plain;f=iso_3166_2/iso_3166_2.xml;hb=HEAD' }

files.each_pair do |file, url|
  `cd #{tmp_path.to_s} && curl -o #{file} "#{url}"`
end

# countries
puts "Importing countries"

country_data_path = tmp_path + 'iso_3166.xml'
file = File.open(country_data_path)
doc = Nokogiri::XML(file)
file.close

countries = []
doc.xpath('//iso_3166_entry').each do |country|
  print '.'
  countries << {
    'alpha_2_code'  => country['alpha_2_code'],
    'alpha_3_code'  => country['alpha_3_code'],
    'numeric_code'  => country['numeric_code'],
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

region_data_path = tmp_path + 'iso_3166_2.xml'
file = File.open(region_data_path)
doc = Nokogiri::XML(file)
file.close

warnings = []

doc.css('iso_3166_country').each do |country|
  code = country['code'].downcase
  regions = []
  country.css('iso_3166_subset').each do |subset|

    type = subset['type'].downcase
    subregions = subset.css('iso_3166_2_entry').map do |subregion|
      data = {
        'code' => subregion['code'].gsub(%r{^#{country['code']}-}, ''),
        'name' => subregion['name'],
        'type' => type
      }

      if subregion['parent']
        parent = regions.find do |r|
          parent_code = r['code']
          parent_code = parent_code.split(/-| /)[1] if parent_code =~ /-| /
          parent_code == subregion['parent']
        end
        if parent
          parent['subregions'] ||= []
          parent['subregions'] << data
        else
          warnings << "warning, did not find parent '#{subregion['parent']}'"
          warnings << subregion
          warnings << regions
          warnings << ''
        end
      else
        regions << data
      end
    end

  end

  sorted_regions = regions.sort_by {|e| e['code'] }
  write_regions_to_path_as_yaml(sorted_regions, "world/#{code}")
  print '.'
end

puts

unless warnings.empty?
  puts warnings.join("\n")
end

FileUtils.rm_rf(tmp_path)
