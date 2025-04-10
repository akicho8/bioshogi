require "./setup"
require 'active_support/core_ext/benchmark'

def f(options = {})
  Benchmark.ms { 20.times { Parser.file_parse("katomomo.csa", options).to_kif } }
end

f()                                          # => 1412.4729999748524
f(validate_feature: false)                       # => 1178.3379999978933
f(ki2_function: false)                      # => 1193.9279999933206
f(validate_feature: false, ki2_function: false) # => 694.497999997111

# つまり candidate_soldiers メソッドを呼ばないように validate_feature: false, ki2_function: false の両方を指定しないといけない
