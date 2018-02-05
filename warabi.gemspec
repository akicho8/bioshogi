lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'warabi/version'

Gem::Specification.new do |spec|
  spec.name         = "warabi"
  spec.version      = Warabi::VERSION
  spec.author       = "akicho8"
  spec.email        = "akicho8@gmail.com"
  spec.homepage     = "https://github.com/akicho8/warabi"
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
  spec.add_development_dependency "stackprof"

  spec.add_dependency "activesupport"
  spec.add_dependency "activemodel"
  spec.add_dependency "actionview"
  spec.add_dependency "org_tp"
  spec.add_dependency "memory_record"
  spec.add_dependency "tree_support"
  spec.add_dependency "tapp"
  spec.add_dependency "pry"
  #pec s.add_dependency "pry-debugger"
end
