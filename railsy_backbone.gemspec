# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'railsy_backbone/version'

Gem::Specification.new do |spec|
  spec.name          = "railsy_backbone"
  spec.version       = RailsyBackbone::VERSION
  spec.authors       = ["Weston Platter"]
  spec.email         = ["westonplatter@gmail.com"]
  spec.description   = %q{inspired by https://github.com/codebrew/backbone-rails + testing & updated Backbone}
  spec.summary       = %q{inspired by https://github.com/codebrew/backbone-rails + testing & updated Backbone}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.files = Dir["lib/**/*"] + Dir["vendor/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  
  spec.add_dependency 'railties',      '>= 3.1.0'
  spec.add_dependency 'coffee-script', '~> 2.2.0'
  spec.add_dependency 'jquery-rails',  '~> 2.2.0'
  spec.add_dependency 'ejs',           '~> 1.1.1'
  
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rails', '~> 3.2.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'sass'
  spec.add_development_dependency 'uglifier'
  # spec.add_development_dependency 'mocha', '~> 0.10.3'
  # spec.add_development_dependency 'turn', '~> 0.8.3'
  # spec.add_development_dependency 'minitest', '~> 2.10.1'
end
