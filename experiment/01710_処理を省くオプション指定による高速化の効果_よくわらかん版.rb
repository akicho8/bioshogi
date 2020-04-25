require "./example_helper"

require "benchmark/ips"
n = 10
Benchmark.ips do |x|
  x.report("default")        { n.times { Parser.file_parse("katomomo.csa").to_kif } }
  x.report("validate_enable")  { n.times { Parser.file_parse("katomomo.csa", validate_enable: false).to_kif } }
  x.report("candidate_enable") { n.times { Parser.file_parse("katomomo.csa", candidate_enable: false).to_kif } }
  x.compare!
end
# >> Warming up --------------------------------------
# >>              default     1.000  i/100ms
# >>        validate_enable     1.000  i/100ms
# >>       candidate_enable     1.000  i/100ms
# >> Calculating -------------------------------------
# >>              default      1.644  (± 0.0%) i/s -      9.000  in   5.474478s
# >>        validate_enable      1.735  (± 0.0%) i/s -      9.000  in   5.188338s
# >>       candidate_enable      1.711  (± 0.0%) i/s -      9.000  in   5.260716s
# >> 
# >> Comparison:
# >>        validate_enable:        1.7 i/s
# >>       candidate_enable:        1.7 i/s - 1.01x  slower
# >>              default:        1.6 i/s - 1.06x  slower
# >> 
