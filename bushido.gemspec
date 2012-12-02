$:.push File.expand_path("../lib", __FILE__)
require "bushido/version"

Gem::Specification.new do |s|
  s.name         = "bushido"
  s.version      = Bushido::VERSION
  s.author       = "akicho8"
  s.email        = "akicho8@gmail.com"
  s.homepage     = "https://github.com/akicho8/bushido"
  s.summary      = "shougi no library no yotei"
  s.description  = "dokomade motibeeshon ga tudukuka wakaranaikedo"

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]

  s.add_dependency "activesupport"
  # s.add_dependency "rain_table", :git => "https://github.com/akicho8/rain_table.git"
  s.add_development_dependency "rspec-core"
end
