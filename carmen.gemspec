# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'carmen/version'

Gem::Specification.new do |s|
  s.name = "carmen"
  s.version = Carmen::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors = ["Jim Benton"]
  s.email = "jim@autonomousmachine.com"
  s.homepage = "http://github.com/jim/carmen"
  s.summary = "A collection of geographic country and state names for Ruby"
  s.description = "A collection of geographic country and state names for Ruby. Also includes replacements for Rails' country_select and state_select plugins"

  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency('mocha')
  s.add_development_dependency('rails')
  s.add_development_dependency('hanna')

  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = Dir.glob("{lib,data}/**/*") + %w(MIT-LICENSE README.rdoc CHANGELOG.md)

  s.require_paths = ["lib"]
end

