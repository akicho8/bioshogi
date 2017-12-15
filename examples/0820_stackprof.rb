require "./example_helper"

require "stackprof"

StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
  5.times do
    ["csa", "ki2", "kif"].each do |e|
      info = Parser.file_parse("katomomo.#{e}")
      info.to_ki2
      info.to_kif
      info.to_csa
    end
  end
end

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Bushido::Point.fetch"
system "stackprof stackprof.dump --method Bushido::Movabler#movable_infos"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 1555 (0.00% miss rate)
# >>   GC: 630 (40.51%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        322  (20.7%)         322  (20.7%)     Bushido::Battler#to_soldier
# >>        235  (15.1%)         128   (8.2%)     Bushido::Soldier#reverse
# >>       3321 (213.6%)          96   (6.2%)     Bushido::SkillMonitor#execute
# >>         46   (3.0%)          44   (2.8%)     Bushido::Position::Base.parse
# >>         35   (2.3%)          35   (2.3%)     Bushido::Position::Base#reverse
# >>        113   (7.3%)          31   (2.0%)     Bushido::Point.fetch
# >>         23   (1.5%)          23   (1.5%)     Bushido::Point#to_xy
# >>         20   (1.3%)          20   (1.3%)     block (4 levels) in memory_record
# >>         17   (1.1%)          17   (1.1%)     Bushido::Point#initialize
# >>         33   (2.1%)          12   (0.8%)     Bushido::Movabler#piece_store
# >>         17   (1.1%)          11   (0.7%)     Bushido::Parser#file_parse
# >>         11   (0.7%)          11   (0.7%)     Bushido::Location#reverse
# >>         29   (1.9%)          10   (0.6%)     Bushido::Position::Vpos.fetch
# >>         35   (2.3%)           8   (0.5%)     Bushido::Position::Hpos.fetch
# >>          7   (0.5%)           7   (0.5%)     Bushido::Piece::VectorMethods#select_vectors2
# >>        169  (10.9%)           7   (0.5%)     Bushido::Runner#execute
# >>         26   (1.7%)           6   (0.4%)     Bushido::Point#==
# >>         14   (0.9%)           6   (0.4%)     Bushido::Board::ReaderMethods#lookup
# >>          6   (0.4%)           6   (0.4%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         10   (0.6%)           5   (0.3%)     Bushido::HandLog#initialize
# >>          5   (0.3%)           5   (0.3%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>        149   (9.6%)           5   (0.3%)     Bushido::Movabler#movable_infos
# >>          7   (0.5%)           5   (0.3%)     Hash#slice
# >>          6   (0.4%)           4   (0.3%)     Hash#transform_keys
# >>          6   (0.4%)           4   (0.3%)     <top (required)>
# >>          4   (0.3%)           4   (0.3%)     #<Module:0x007fb7ec363ef8>.size_type
# >>         17   (1.1%)           4   (0.3%)     <top (required)>
# >>          4   (0.3%)           4   (0.3%)     Bushido::Position::Hpos#number_format
# >>          4   (0.3%)           4   (0.3%)     #<Module:0x007fb7ebb897c8>.kconv
# >>          5   (0.3%)           4   (0.3%)     ActiveSupport::Duration.===
# >> Bushido::Point.fetch (/Users/ikeda/src/bushido/lib/bushido/point.rb:36)
# >>   samples:    31 self (2.0%)  /    113 total (7.3%)
# >>   callers:
# >>       62  (   54.9%)  Bushido::Point#reverse
# >>       31  (   27.4%)  Bushido::Point.[]
# >>       10  (    8.8%)  Bushido::Point#vector_add
# >>        6  (    5.3%)  Bushido::Runner#read_point
# >>        2  (    1.8%)  Bushido::Player#move_to
# >>        2  (    1.8%)  Bushido::Runner#execute
# >>   callees (82 total):
# >>       35  (   42.7%)  Bushido::Position::Hpos.fetch
# >>       29  (   35.4%)  Bushido::Position::Vpos.fetch
# >>       17  (   20.7%)  Bushido::Point#initialize
# >>        1  (    1.2%)  Bushido::Point#to_xy
# >>   code:
# >>                                   |    36  |       def parse(value)
# >>                                   |    37  |         x = nil
# >>                                   |    38  |         y = nil
# >>                                   |    39  | 
# >>                                   |    40  |         case value
# >>    17    (1.1%) /    17   (1.1%)  |    41  |         when Array
# >>                                   |    42  |           a, b = value
# >>    24    (1.5%)                   |    43  |           x = Position::Hpos.fetch(a)
# >>    19    (1.2%)                   |    44  |           y = Position::Vpos.fetch(b)
# >>                                   |    45  |         when Point
# >>     1    (0.1%)                   |    46  |           a, b = value.to_xy
# >>     3    (0.2%)                   |    47  |           x = Position::Hpos.fetch(a)
# >>     3    (0.2%)                   |    48  |           y = Position::Vpos.fetch(b)
# >>                                   |    49  |         when String
# >>    11    (0.7%) /    11   (0.7%)  |    50  |           if md = value.match(/\A(?<x>.)(?<y>.)\z/)
# >>     8    (0.5%)                   |    51  |             x = Position::Hpos.fetch(md[:x])
# >>     7    (0.5%)                   |    52  |             y = Position::Vpos.fetch(md[:y])
# >>                                   |    53  |           else
# >>                                   |    54  |             raise PointSyntaxError, "座標を2文字で表記していません : #{value.inspect}"
# >>                                   |    55  |           end
# >>                                   |    56  |         else
# >>                                   |    57  |           raise MustNotHappen, "引数が異常です : #{value.inspect}"
# >>     1    (0.1%) /     1   (0.1%)  |    58  |         end
# >>                                   |    59  | 
# >>    19    (1.2%) /     2   (0.1%)  |    60  |         new(x, y)
# >>                                   |    61  |       end
# >> Bushido::Movabler#movable_infos (/Users/ikeda/src/bushido/lib/bushido/movabler.rb:33)
# >>   samples:     5 self (0.3%)  /    149 total (9.6%)
# >>   callers:
# >>       72  (   48.3%)  Bushido::Movabler#movable_infos
# >>       53  (   35.6%)  Bushido::Runner#execute
# >>       20  (   13.4%)  Set#each
# >>        4  (    2.7%)  Bushido::Battler#movable_infos
# >>   callees (144 total):
# >>       72  (   50.0%)  Bushido::Movabler#movable_infos
# >>       33  (   22.9%)  Bushido::Movabler#piece_store
# >>       20  (   13.9%)  Set#each
# >>        6  (    4.2%)  Bushido::Board::ReaderMethods#lookup
# >>        5  (    3.5%)  Bushido::Point#vector_add
# >>        4  (    2.8%)  Bushido::Piece::VectorMethods#select_vectors2
# >>        3  (    2.1%)  Hash#slice
# >>        1  (    0.7%)  Bushido::Point#invalid?
# >>   code:
# >>                                   |    33  |     def movable_infos(player, soldier)
# >>     4    (0.3%) /     4   (0.3%)  |    34  |       Enumerator.new do |yielder|
# >>     7    (0.5%)                   |    35  |         vecs = soldier[:piece].select_vectors2(soldier.slice(:promoted, :location))
# >>    46    (3.0%)                   |    36  |         vecs.each do |vec|
# >>                                   |    37  |           pt = soldier[:point]
# >>    46    (3.0%)                   |    38  |           loop do
# >>     5    (0.3%)                   |    39  |             pt = pt.vector_add(vec)
# >>                                   |    40  | 
# >>                                   |    41  |             # 盤外に出てしまったら終わり
# >>     1    (0.1%)                   |    42  |             if pt.invalid?
# >>                                   |    43  |               break
# >>                                   |    44  |             end
# >>                                   |    45  | 
# >>     6    (0.4%)                   |    46  |             target = player.board.lookup(pt)
# >>                                   |    47  | 
# >>                                   |    48  |             if target && !target.kind_of?(Battler)
# >>                                   |    49  |               raise UnconfirmedObject, "盤上に得体の知れないものがいます : #{target.inspect}"
# >>                                   |    50  |             end
# >>                                   |    51  | 
# >>                                   |    52  |             # 自分の駒に衝突したら終わり
# >>                                   |    53  |             if target && target.player == player
# >>                                   |    54  |               break
# >>                                   |    55  |             end
# >>                                   |    56  | 
# >>                                   |    57  |             # 自分の駒以外(相手駒 or 空)なので行ける
# >>    33    (2.1%)                   |    58  |             piece_store(player, soldier, pt, yielder)
# >>                                   |    59  | 
# >>                                   |    60  |             # 相手駒があるのでこれ以上は進めない
# >>                                   |    61  |             if target
# >>                                   |    62  |               break
# >>                                   |    63  |             end
# >>                                   |    64  | 
# >>                                   |    65  |             # 一歩だけベクトルならそれで終わり
# >>     1    (0.1%) /     1   (0.1%)  |    66  |             if vec.kind_of?(OnceVector)
# >>                                   |    67  |               break
