# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'railsy_backbone/version'

Gem::Specification.new do |s|
  s.name          = "railsy_backbone"
  s.version       = RailsyBackbone::VERSION
  s.authors       = ["Weston Platter"]
  s.email         = ["westonplatter@gmail.com"]
  s.description   = %q{Inspired by backbone-rails with testing & updated Backbone}
  s.summary       = %q{Inspired by backbone-rails with testing & updated Backbone}
  s.homepage      = "http://github.com/westonplatter/railsy_backbone"
  s.license       = "BSD-3"

  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  
  s.files = Dir["lib/**/*"] + Dir["vendor/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  
  s.add_dependency 'railties',      '>= 3.1.0'
  s.add_dependency 'coffee-script' #, '~> 2.2.0'
  s.add_dependency 'jquery-rails'  #, '~> 3.0.0'
  s.add_dependency 'ejs',           '~> 1.1.1'
  
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'sass'
  s.add_development_dependency 'uglifier'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rails-dummy'
  s.add_development_dependency 'mocha'
end
