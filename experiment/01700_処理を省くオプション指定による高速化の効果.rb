require "./example_helper"
require 'active_support/core_ext/benchmark'

def f(options = {})
  Benchmark.ms { 20.times { Parser.file_parse("katomomo.csa", options).to_kif } }
end

f()                                          # => 1412.4729999748524
f(validate_skip: true)                       # => 1178.3379999978933
f(candidate_skip: true)                      # => 1193.9279999933206
f(validate_skip: true, candidate_skip: true) # => 694.497999997111

# つまり candidate_soldiers メソッドを呼ばないように validate_skip: true, candidate_skip: true の両方を指定しないといけない
