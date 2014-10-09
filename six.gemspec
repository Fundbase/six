# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'six/version'

Gem::Specification.new do |spec|
  spec.name          = 'six'
  spec.version       = SIX::VERSION
  spec.authors       = ['Volodymyr Shatsky']
  spec.email         = ['shockone89@gmail.com']
  spec.summary       = %q{A Ruby wrapper for SIX XML API.}
  spec.description   = %q{Allows to interact with SIX Financial Information API without testing your pain tolerance.}
  spec.homepage      = 'https://github.com/Fundbase/six'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty',      '~> 0.13'
  spec.add_dependency 'activesupport', '>= 3'

  spec.add_development_dependency 'bundler',  '~> 1.6'
  spec.add_development_dependency 'rake',     '~> 10.3'
  spec.add_development_dependency 'rspec',    '~> 3.1'
  spec.add_development_dependency 'webmock',  '~> 1.19'
  spec.add_development_dependency 'sinatra',  '~> 1.4'
  spec.add_development_dependency 'pry',      '~> 0.10'
  spec.add_development_dependency 'rubocop',  '~> 0.26'
end
