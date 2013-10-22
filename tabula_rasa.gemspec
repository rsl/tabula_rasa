# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tabula_rasa/version'

Gem::Specification.new do |spec|
  spec.name          = "tabula_rasa"
  spec.version       = TabulaRasa::VERSION
  spec.authors       = ["RSL"]
  spec.email         = ["sconds@gmail.com"]
  spec.description   = %q{An opinionated yet simple table generator for ActionPack/Rails}
  spec.summary       = %q{An opinionated yet simple table generator for ActionPack/Rails}
  spec.homepage      = "https://github.com/rsl/tabula_rasa"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
