require "./setup"
piller_cop = PillerCop.new
piller_cop.counts                 # => [0, 0, 0, 0, 0, 0, 0, 0, 0]
piller_cop.set(Place["21"])
piller_cop.counts                 # => [0, 0, 0, 0, 0, 0, 0, 1, 0]
piller_cop.set(Place["22"])
piller_cop.set(Place["23"])
piller_cop.set(Place["24"])
piller_cop.set(Place["25"])
piller_cop.set(Place["26"])
piller_cop.set(Place["27"])
piller_cop.set(Place["28"])
piller_cop.active                 # => false
piller_cop.set(Place["29"])
piller_cop.counts                 # => [0, 0, 0, 0, 0, 0, 0, 9, 0]
piller_cop.active                 # => true
piller_cop.remove(Place["29"])
piller_cop.active                 # => false
piller_cop.counts                 # => [0, 0, 0, 0, 0, 0, 0, 8, 0]

piller_cop = PillerCop.new
piller_cop.set(Place["21"])
piller_cop.active = true
piller_cop.reset
piller_cop.counts                # => [0, 0, 0, 0, 0, 0, 0, 0, 0]
piller_cop.active                # => false

piller_cop = PillerCop.new
piller_cop.remove(Place["21"]) rescue $! # => #<Bioshogi::MustNotHappen: 2の列の駒の数がマイナスになろうとしていています>

piller_cop = PillerCop.new
9.times { piller_cop.set(Place["21"]) }
piller_cop.set(Place["21"]) rescue $! # => #<Bioshogi::MustNotHappen: 2の列に10個目の駒を配置しようとしています。棋譜を二重に読ませようとしていませんか？>
