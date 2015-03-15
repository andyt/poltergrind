# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poltergrind/version'

Gem::Specification.new do |spec|
  spec.name          = 'poltergrind'
  spec.version       = Poltergrind::VERSION
  spec.authors       = ['Andy Triggs']
  spec.email         = ['andy.triggs@gmail.com']
  spec.summary       = 'Poltergrind: realistic load testing'
  spec.description   = 'Load testing tool using concurrent headless Webkit browsers via Poltergeist and Sidekiq.'
  spec.homepage      = 'http://github.com/andyt/poltergrind'
  spec.license       = 'MIT'

  spec.files         = Dir['README.md', 'LICENSE.txt', '{bin|spec|features|lib}/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'sidekiq', '~> 3.0'
  spec.add_dependency 'poltergeist', '~> 1.6.0'
  spec.add_dependency 'statsd-ruby', '~> 1.2'
  spec.add_dependency 'pry'
  spec.add_dependency 'rspec', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'foreman'
  spec.add_development_dependency 'term-ansicolor'
end
