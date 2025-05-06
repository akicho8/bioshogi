require "./setup"
def _
  "%.1f ms" % Benchmark.ms { 1000000.times { yield } }
end
a = Column.fetch("1")
_ { a.white_then_flip(:white) } # => "518.8 ms"

# Dimension.change([2, 2]) do
# puts Board.create_by_preset("平手").to_kif
# end

Column.fetch("1").distance(Column.fetch("3")) # => 2
Column.fetch("3").distance(Column.fetch("1")) # => 2

