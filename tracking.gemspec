# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tracking/version'

Gem::Specification.new do |spec|
  spec.name          = "tracking"
  spec.version       = Tracking::VERSION
  spec.authors       = ["Nicolas McCurdy"]
  spec.email         = ["thenickperson@gmail.com"]
  spec.description   = 'See README for more information.'
  spec.summary       = 'A simple and configurable command line time tracker.'
  spec.homepage      = "http://github.com/thenickperson/tracking"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "colorize", "~> 0.5"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.12"

  spec.add_development_dependency "rdoc", "~> 3.12"
  spec.add_development_dependency "simplecov", "~> 0.7"
  spec.add_development_dependency "yard", "~> 0.8"

  if RUBY_PLATFORM == "java"
    spec.add_development_dependency "kramdown", "~> 0.14"
  else
    spec.add_development_dependency "redcarpet", "~> 2.2"
  end
end
