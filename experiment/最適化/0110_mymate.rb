require "../setup"

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：飛角金銀桂香歩
+------+
  | ・v玉|
| ・ 金|
| ・ 金|
+------+
  先手の持駒：飛角金銀桂香歩
手数＝1
EOT

block = -> {
  # # 詰む場合はそれなりに重い
  # ms = Benchmark.ms { mediator.player_at(:white).my_mate? }
  # assert { ms >= 50.0 }

  # でも詰まない場合の処理は早い
  mediator.player_at(:black).my_mate?
}

# require "stackprof"
StackProf.run(mode: :object, out: "/tmp/stackprof-cpu.dump") { block.call }
# StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
# StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
# StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do

ms = Benchmark.ms { mediator.player_at(:black).my_mate? }
ms                              # => 0.07499987259507179

# GC.start
# GC.disable
# GC.enable
# assert { ms < 1130 }

puts `stackprof /tmp/stackprof-cpu.dump`
# >> ==================================
# >>   Mode: object(1)
# >>   Samples: 236 (0.00% miss rate)
# >>   GC: 0 (0.00%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        155  (65.7%)          19   (8.1%)     Bioshogi::Movabler#move_list
# >>         16   (6.8%)          16   (6.8%)     Array.[]
# >>         27  (11.4%)          11   (4.7%)     Class#new
# >>         22   (9.3%)           9   (3.8%)     Bioshogi::Place#vector_add
# >>          9   (3.8%)           9   (3.8%)     #<Class:0x00000001022fb400>.proc
# >>          9   (3.8%)           9   (3.8%)     Bioshogi::Piece::PieceVector#pattern_king
# >>         23   (9.7%)           8   (3.4%)     Bioshogi::Player::SoldierMethods#soldiers
# >>         10   (4.2%)           8   (3.4%)     #<Module:0x0000000105d9b2b8>#<=>
# >>         31  (13.1%)           7   (3.0%)     Bioshogi::Piece::PieceVector#build_vectors
# >>          6   (2.5%)           6   (2.5%)     Enumerator#initialize
# >>        199  (84.3%)           6   (2.5%)     Enumerator::Generator#each
# >>         85  (36.0%)           6   (2.5%)     Bioshogi::Piece::PieceVector#all_vectors
# >>        200  (84.7%)           6   (2.5%)     Bioshogi::PlayerBrainMod#move_hands
# >>          5   (2.1%)           5   (2.1%)     Bioshogi::Place#to_xy
# >>         96  (40.7%)           5   (2.1%)     Bioshogi::Piece#all_vectors
# >>          6   (2.5%)           4   (1.7%)     Bioshogi::Piece::VectorMethods#piece_vector
# >>         58  (24.6%)           4   (1.7%)     Bioshogi::Piece::PieceVector#select_vectors
# >>          7   (3.0%)           4   (1.7%)     Bioshogi::Location#flip
# >>          4   (1.7%)           4   (1.7%)     Array#compact
# >>         18   (7.6%)           4   (1.7%)     Enumerable#collect
# >>        216  (91.5%)           4   (1.7%)     Bioshogi::PlayerBrainMod#mate_advantage?
# >>         11   (4.7%)           3   (1.3%)     Bioshogi::PlayerBrainMod#king_capture_move_hands
# >>         99  (41.9%)           3   (1.3%)     Bioshogi::Soldier#all_vectors
# >>         13   (5.5%)           3   (1.3%)     Bioshogi::Piece::PieceVector#basic_once_vectors
# >>          3   (1.3%)           3   (1.3%)     Enumerable#count
# >>         15   (6.4%)           3   (1.3%)     Set#each
# >>         50  (21.2%)           3   (1.3%)     Bioshogi::Piece::PieceVector#basic_vectors
# >>         21   (8.9%)           3   (1.3%)     Bioshogi::Piece::PieceVector#normalized_vectors
# >>          8   (3.4%)           3   (1.3%)     Bioshogi::Soldier#move_list
# >>         11   (4.7%)           3   (1.3%)     Bioshogi::Pvec#flip_sign
