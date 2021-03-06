# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nvlope/version'

Gem::Specification.new do |spec|
  spec.name          = "nvlope"
  spec.version       = Nvlope::VERSION
  spec.authors       = ["Jared Grippe"]
  spec.email         = ["jared@other.io"]
  spec.summary       = %q{Ruby wrapper for the nvlope.com API}
  spec.description   = %q{Ruby wrapper for the nvlope.com API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mail"
  spec.add_dependency "httparty"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-debugger"
end
