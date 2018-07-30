# coding: utf-8

require_relative 'lib/waff/version'

Gem::Specification.new do |spec|
  spec.name          = "waff"
  spec.version       = Waff::VERSION
  spec.authors       = ["Armando Andini"]
  spec.email         = ["armando.andini@gmail.com"]
  spec.summary       = %q{Helps you with github flow based on Waffle tool}
  spec.homepage      = "https://github.com/antico5/waff"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['waff']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", '~> 0.16'
end
