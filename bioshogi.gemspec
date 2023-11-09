lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) if !$LOAD_PATH.include?(lib)
require 'bioshogi/version'

Gem::Specification.new do |spec|
  spec.name         = "bioshogi"
  spec.version      = Bioshogi::VERSION
  spec.author       = "Akira Ikeda"
  spec.email        = "pinpon.ikeda@gmail.com"
  spec.homepage     = "https://github.com/akicho8/bioshogi"
  spec.summary      = "Shogi library"
  spec.description  = "Shogi library"
  spec.platform     = Gem::Platform::RUBY
  spec.license      = "AGPL-3.0"

  # https://pocke.hatenablog.com/entry/2020/10/24/171955
  spec.files         = `git ls-files`.split($/).grep_v(%r{^(test|spec|features|demo|algorithm|experiment|min_max|bioshogi.png|doc)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = [] # spec.files.grep(%r{^(test|spec|features|demo|algorithm|experiment|min_max)/})
  spec.require_paths = ["lib"]
  spec.rdoc_options  = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "stackprof"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "byebug"

  spec.add_dependency "activesupport", ">= 7.1.0"
  spec.add_dependency "actionview"
  spec.add_dependency "table_format"
  spec.add_dependency "memory_record"
  spec.add_dependency "tree_support"
  spec.add_dependency "color"
  spec.add_dependency "zeitwerk"
  spec.add_dependency "thor"
  spec.add_dependency "rmagick", ">= 5.0.0"
  spec.add_dependency "systemu"
  spec.add_dependency "rubyzip", ">= 2.3.0"
  spec.add_dependency "faraday"
end
