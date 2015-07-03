# -*- encoding: utf-8 -*-

require File.expand_path("../lib/settingable/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "settingable"
  gem.version       = Settingable::VERSION
  gem.summary       = "Handles configuring your gems."
  gem.description   = "Handles configuring your gems."
  gem.license       = "MIT"
  gem.authors       = ["Jeremy Rodi"]
  gem.email         = "redjazz96@gmail.com"
  gem.homepage      = "https://github.com/medcat/settingable"

  gem.files         = `git ls-files`.split($RS)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "yard"

  gem.add_dependency "deep_merge"
end
