require "./setup"
def _
  "%.1f ms" % Benchmark.ms { 1000000.times { yield } }
end
a = DimensionColumn.fetch("1")
_ { a.white_then_flip(:white) } # => "461.6 ms"

# Dimension.change([2, 2]) do
# puts Board.create_by_preset("平手").to_kif
# end
