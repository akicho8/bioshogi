# frozen-string-literal: true

#
# h = CounterHash.new
# h[:x]                           # => 0
# h.increment(:x)                 # => 1
# h.keys                          # => [:x]
# h.decrement(:x)                 # => 0
# h.keys                          # => []
# h.count                         # => 0
#
module Bioshogi
  class CounterHash < Hash
    def initialize
      super(0)
    end

    def increment(key)
      self[key] += 1
    end

    def decrement(key)
      self[key] -= 1
      zero_then_delete(key)
    end

    private

    def zero_then_delete(key)
      if self[key].zero?
        delete(key)
      end
    end
  end
end
