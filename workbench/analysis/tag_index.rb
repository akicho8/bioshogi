require "#{__dir__}/setup"

tag = Bioshogi::Analysis::TagIndex.fetch("嬉野流")
Bioshogi::Analysis::TagIndex.fetch(tag) # => <嬉野流>
