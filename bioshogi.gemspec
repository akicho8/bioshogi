lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bioshogi/version'

Gem::Specification.new do |spec|
  spec.name         = "bioshogi"
  spec.version      = Bioshogi::VERSION
  spec.author       = "akicho8"
  spec.email        = "akicho8@gmail.com"
  spec.homepage     = "https://github.com/akicho8/bioshogi"
  spec.summary      = "Shogi library"
  spec.description  = "Shogi library"
  spec.platform     = Gem::Platform::RUBY

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.rdoc_options  = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "stackprof"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rmagick"

  spec.add_dependency "activesupport"
  spec.add_dependency "actionview"
  spec.add_dependency "table_format"
  spec.add_dependency "memory_record"
  spec.add_dependency "tree_support"
  spec.add_dependency "systemu"
end
