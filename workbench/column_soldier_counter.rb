require "#{__dir__}/setup"
column_soldier_counter = ColumnSoldierCounter.new
column_soldier_counter.counts                 # => [0, 0, 0, 0, 0, 0, 0, 0, 0]
column_soldier_counter.set(Place["21"])
column_soldier_counter.counts                 # => [0, 0, 0, 0, 0, 0, 0, 1, 0]
column_soldier_counter.set(Place["22"])
column_soldier_counter.set(Place["23"])
column_soldier_counter.set(Place["24"])
column_soldier_counter.set(Place["25"])
column_soldier_counter.set(Place["26"])
column_soldier_counter.set(Place["27"])
column_soldier_counter.set(Place["28"])
column_soldier_counter.active                 # => false
column_soldier_counter.set(Place["29"])
column_soldier_counter.counts                 # => [0, 0, 0, 0, 0, 0, 0, 9, 0]
column_soldier_counter.active                 # => false
column_soldier_counter.remove(Place["29"])
column_soldier_counter.active                 # => false
column_soldier_counter.counts                 # => [0, 0, 0, 0, 0, 0, 0, 8, 0]

column_soldier_counter = ColumnSoldierCounter.new
column_soldier_counter.set(Place["21"])
column_soldier_counter.active = true
column_soldier_counter.reset
column_soldier_counter.counts                # => [0, 0, 0, 0, 0, 0, 0, 0, 0]
column_soldier_counter.active                # => false

column_soldier_counter = ColumnSoldierCounter.new
column_soldier_counter.remove(Place["21"]) rescue $! # => #<Bioshogi::MustNotHappen: 2の列の駒の数がマイナスになろうとしている>

column_soldier_counter = ColumnSoldierCounter.new
9.times { column_soldier_counter.set(Place["21"]) }
column_soldier_counter.set(Place["21"]) rescue $! # => #<Bioshogi::MustNotHappen: 2の列に10個目の駒を配置しようとしています。棋譜を二重に読ませようとしていませんか？>
