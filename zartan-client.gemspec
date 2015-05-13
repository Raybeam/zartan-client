# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zartan/client/version'

Gem::Specification.new do |spec|
  spec.name          = "zartan-client"
  spec.version       = Zartan::Client::VERSION
  spec.authors       = ["David Hollis"]
  spec.email         = ["dhollis@raybeam.com"]
  spec.summary       = %q{Simple client for the Zartan proxy manager.}
  spec.homepage      = "http://github.com/Raybeam/zartan-client"
  spec.license       = "BSD-3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize"
  
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
