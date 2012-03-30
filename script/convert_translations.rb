require 'yaml'
require 'pathname'
require 'fileutils'

YAML::ENGINE.yamler = 'psych'

ROOT = Pathname.new(__FILE__ + '/../..').expand_path
DEPRECATED_DATA_PATH = ROOT + 'deprecated_data'

def convert_country_files
  Dir[DEPRECATED_DATA_PATH + 'countries/*.yml'].each do |file|
    puts "Converting #{file}"

    countries = YAML.load_file(file)
    locale = Pathname.new(file).basename('.yml').to_s

    sorted = countries.sort_by {|(name, code)| code}
    converted = sorted.inject({}) do |hash, (name, code)|
      hash[code.downcase]= { 'common_name' => nil,
                             'name' => name,
                             'official_name' => nil }
      hash
    end

    wrapped = {
      locale => {
        'world' => converted
      }
    }

    # Make the locale's directory
    locale_path = ROOT + "locale/#{locale}"
    FileUtils.mkdir_p(locale_path)

    File.open(locale_path + "world.yml", 'w') do |f|
      YAML.dump(wrapped, f)
    end

  end
end

convert_country_files
