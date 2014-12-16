# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'camt/version'

Gem::Specification.new do |spec|
  spec.name          = "camt"
  spec.version       = Camt::VERSION
  spec.authors       = ["Reinier de Lange"]
  spec.email         = ["r.j.delange@nedforce.nl"]
  spec.description   = %q{A gem for parsing CAMT.053 files}
  spec.summary       = %q{A gem for parsing CAMT.053 file}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
