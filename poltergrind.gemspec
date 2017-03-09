# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poltergrind/version'

Gem::Specification.new do |spec|
  spec.name          = 'poltergrind'
  spec.version       = Poltergrind::VERSION
  spec.authors       = ['Andy Triggs']
  spec.email         = ['andy.triggs@gmail.com']
  spec.summary       = 'Poltergrind: full-stack performance testing using the Capybara DSL.'
  spec.description   = 'Performance testing tool using the Capybara DSL and concurrent headless Webkit browsers via Poltergeist + Sidekiq.'
  spec.homepage      = 'http://github.com/andyt/poltergrind'
  spec.license       = 'MIT'

  spec.files         = Dir['README.md', 'LICENSE.txt', '{bin|spec|features|lib}/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'sidekiq', '~> 3.0'
  spec.add_dependency 'sidekiq-web'
  spec.add_dependency 'sidekiq-enqueuer'
  spec.add_dependency 'poltergeist', '~> 1.6.0'
  spec.add_dependency 'statsd-ruby', '~> 1.2'
  spec.add_dependency 'pry'
  spec.add_dependency 'rspec', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'foreman'
  spec.add_development_dependency 'term-ansicolor'
  spec.add_development_dependency 'puma'
end
