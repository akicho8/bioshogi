require "#{__dir__}/setup"
h = CounterHash.new
h[:x]                           # => 0
h.increment(:x)                 # => 1
h.keys                          # => [:x]
h.decrement(:x)                 # => 0
h.keys                          # => []
h.count                         # => 0
