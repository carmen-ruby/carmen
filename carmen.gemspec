Gem::Specification.new do |s|
  s.name = %q{carmen}
  s.summary = %q{A collection of geographic country and state names for Ruby}
  s.description = %q{A collection of geographic country and state names for Ruby. Also includes replacements for Rails' country_select and state_select plugins}
  s.version = "1.0.0.pre"
  s.authors = ["Jim Benton"]
  s.email = %q{jim@autonomousmachine.com}
  s.date = %q{2012-03-23}
  s.homepage = %q{http://github.com/jim/carmen}

  s.required_rubygems_version = '>= 1.3.6'
  s.require_paths = ["lib"]
  s.files = Dir.glob("{lib,iso_data}/**/*") + %w(MIT-LICENSE README.md CHANGELOG.md)

  s.add_development_dependency('minitest', ["= 2.6.1"])
  s.add_development_dependency('nokogiri')
  s.add_development_dependency('rake', '0.9.2.2')
end
