require "./setup"
def _
  "%.1f ms" % Benchmark.ms { 1.times { yield } }
end
_ { Parser.file_parse("../microcosmos.kif").container } # => "604.9 ms"
