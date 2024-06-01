require "./setup"

v = V[1, 2]

def _ = "%.2f ms" % Benchmark.ms { 100000.times { yield } }
_ { v.hash }              # => "13.19 ms"
_ { v.x.hash ^ v.y.hash } # => "9.76 ms"
