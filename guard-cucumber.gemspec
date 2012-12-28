# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'guard/cucumber/version'

Gem::Specification.new do |s|
  s.name        = 'guard-cucumber'
  s.version     = Guard::CucumberVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Michael Kessler']
  s.email       = ['michi@netzpiraten.ch']
  s.homepage    = 'http://github.com/netzpirat/guard-cucumber'
  s.summary     = 'Guard plugin for Cucumber'
  s.description = 'Guard::Cucumber automatically run your features (much like autotest)'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'guard-cucumber'

  s.add_dependency 'guard',       '>= 1.1.0'
  s.add_dependency 'cucumber',    '>= 1.2.0'

  s.add_development_dependency 'bundler', '~> 1.1'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.require_path = 'lib'
end
