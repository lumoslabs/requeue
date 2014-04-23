# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'requeue/version'

Gem::Specification.new do |spec|
  spec.name          = "requeue"
  spec.version       = Requeue::VERSION
  spec.authors       = ["Eric Fode"]
  spec.email         = ["efode@lumoslabs.com"]
  spec.summary       = %q{A simple resque based queue}
  spec.description   = %q{A a very simple resque based queue}
  spec.homepage      = "github.com/lumoslabs/requeue"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
