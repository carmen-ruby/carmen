require 'nokogiri'
require 'yaml'
require 'pathname'

begin
  require 'ftools'
rescue LoadError
  require 'fileutils' # ftools is now fileutils in Ruby 1.9
end

puts "Downloading data"

data_path = Pathname.new(File.expand_path('../../iso_data', __FILE__))
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
    'official_name' => country['official_name']
  }
end

puts

File.open(data_path + 'world.yml', 'w') do |f|
  f.write countries.to_yaml
end

# regions
puts "Importing regions"

region_data_path = tmp_path + 'iso_3166_2.xml'
file = File.open(region_data_path)
doc = Nokogiri::XML(file)
file.close

warnings = []

doc.css('iso_3166_country').each do |country|
  code = country['code'].downcase
  print '.'
  regions = []
  country.css('iso_3166_subset').each do |subset|

    type = subset['type'].downcase
    subset.css('iso_3166_2_entry').each do |subregion|
      data = {
        'code' => subregion['code'],
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

    dir = data_path + 'regions'
    FileUtils.mkdir_p(dir)
    File.open(dir + "#{code}.yml", 'w') do |f|
      f.write regions.to_yaml
    end
  end
end

puts

unless warnings.empty?
  puts warnings.join("\n")
end

FileUtils.rm_rf(tmp_path)
