# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina_revisioneer/version'

Gem::Specification.new do |spec|
  spec.name          = "mina-revisioneer"
  spec.version       = MinaRevisioneer::VERSION
  spec.authors       = ["Raphael Randschau"]
  spec.email         = ["nicolai86@me.com"]
  spec.description   = %q{push deployment informations to revisioneer}
  spec.summary       = %q{push deployment informations to revisioneer}
  spec.homepage      = "http://blog.nicolai86.eu"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "rugged", "~> 0.19"
end
