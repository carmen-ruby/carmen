# -*- encoding: utf-8 -*-

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "carmen/version"

Gem::Specification.new do |s|
  s.name = %q{carmen}
  s.summary = %q{A collection of geographic region data for Ruby}
  s.description = %q{Includes data from the Debian iso-data project.}
  s.version = Carmen::VERSION
  s.authors = ["Jim Benton"]
  s.email = %q{jim@autonomousmachine.com}
  s.homepage = %q{http://github.com/jim/carmen}

  s.required_rubygems_version = '>= 1.3.6'
  s.require_paths = ["lib"]
  s.files = Dir.glob("{lib,iso_data,locale}/**/*") + %w(MIT-LICENSE README.md CHANGELOG.md)

  s.add_development_dependency('minitest', ["= 2.6.1"])
  s.add_development_dependency('nokogiri')
  s.add_development_dependency('rake', '0.9.2.2')
  s.add_development_dependency('i18n')
  s.add_dependency('activesupport', '>= 3.0.0')
end
