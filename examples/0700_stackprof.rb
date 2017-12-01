require "./example_helper"

require "stackprof"

StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
  10.times do
    ["csa", "ki2", "kif"].each do |e|
      info = Parser.file_parse("katomomo.#{e}")
      info.to_ki2
      info.to_kif
      info.to_csa
    end
  end
end

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Bushido::Point.parse"
system "stackprof stackprof.dump --method Bushido::Movabler#movable_infos"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 401 (0.00% miss rate)
# >>   GC: 96 (23.94%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>         39   (9.7%)          37   (9.2%)     Bushido::Position::Base.parse
# >>         32   (8.0%)          19   (4.7%)     Bushido::Parser#file_parse
# >>         20   (5.0%)          16   (4.0%)     ActiveSupport::Duration::Scalar#-
# >>         16   (4.0%)          16   (4.0%)     block (4 levels) in memory_record
# >>         15   (3.7%)          14   (3.5%)     Bushido::Position::Hpos#number_format
# >>         62  (15.5%)          13   (3.2%)     Bushido::Point.parse
# >>         30   (7.5%)          13   (3.2%)     Bushido::Movabler#piece_store
# >>         11   (2.7%)          11   (2.7%)     Bushido::Position::Vpos#number_format
# >>         39   (9.7%)          10   (2.5%)     Bushido::Player#put_on_with_valid
# >>         10   (2.5%)          10   (2.5%)     #<Module:0x007fc139ade8d0>.kconv
# >>         24   (6.0%)          10   (2.5%)     Bushido::Board::ReaderMethods#lookup
# >>          7   (1.7%)           7   (1.7%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>          5   (1.2%)           5   (1.2%)     Bushido::Point#to_xy
# >>          5   (1.2%)           5   (1.2%)     ActiveSupport::Duration#initialize
# >>        171  (42.6%)           5   (1.2%)     Bushido::Movabler#movable_infos
# >>          5   (1.2%)           5   (1.2%)     Bushido::HandLog::OfficialFormatter#initialize
# >>          9   (2.2%)           5   (1.2%)     Bushido::Position::Base#valid?
# >>         11   (2.7%)           5   (1.2%)     Bushido::Parser#source_normalize
# >>          5   (1.2%)           5   (1.2%)     Bushido::Battler#to_soldier
# >>          4   (1.0%)           4   (1.0%)     ActiveSupport::Duration#to_i
# >>         39   (9.7%)           4   (1.0%)     Set#each
# >>          4   (1.0%)           4   (1.0%)     ActiveSupport::Duration.===
# >>          4   (1.0%)           4   (1.0%)     Bushido::Position::Base.value_range
# >>          9   (2.2%)           4   (1.0%)     Bushido::Runner#point_same?
# >>          8   (2.0%)           4   (1.0%)     Bushido::HandLog#initialize
# >>         24   (6.0%)           4   (1.0%)     Bushido::Position::Hpos.parse
# >>          8   (2.0%)           4   (1.0%)     Bushido::Board::UpdateMethods#put_on
# >>         38   (9.5%)           3   (0.7%)     Bushido::BoardParser::CsaBoardParser#parse
# >>          3   (0.7%)           3   (0.7%)     Bushido::Player#board
# >>         22   (5.5%)           3   (0.7%)     Bushido::Position::Vpos.parse
# >> Bushido::Point.parse (/Users/ikeda/src/bushido/lib/bushido/point.rb:36)
# >>   samples:    13 self (3.2%)  /     62 total (15.5%)
# >>   callers:
# >>       25  (   40.3%)  Bushido::Point.[]
# >>       14  (   22.6%)  Bushido::Point#vector_add
# >>       13  (   21.0%)  Bushido::Runner#execute
# >>        9  (   14.5%)  Bushido::Runner#read_point
# >>        1  (    1.6%)  Bushido::Battler#initialize
# >>   callees (49 total):
# >>       24  (   49.0%)  Bushido::Position::Hpos.parse
# >>       22  (   44.9%)  Bushido::Position::Vpos.parse
# >>        2  (    4.1%)  Bushido::Point#initialize
# >>        1  (    2.0%)  Bushido::Point#to_xy
# >>   code:
# >>                                   |    36  |       def parse(value)
# >>                                   |    37  |         x = nil
# >>                                   |    38  |         y = nil
# >>                                   |    39  | 
# >>                                   |    40  |         case value
# >>    10    (2.5%) /    10   (2.5%)  |    41  |         when Array
# >>                                   |    42  |           a, b = value
# >>     7    (1.7%)                   |    43  |           x = Position::Hpos.parse(a)
# >>     5    (1.2%)                   |    44  |           y = Position::Vpos.parse(b)
# >>                                   |    45  |         when Point
# >>     1    (0.2%)                   |    46  |           a, b = value.to_xy
# >>     8    (2.0%)                   |    47  |           x = Position::Hpos.parse(a)
# >>     3    (0.7%)                   |    48  |           y = Position::Vpos.parse(b)
# >>                                   |    49  |         when String
# >>     2    (0.5%) /     2   (0.5%)  |    50  |           if md = value.match(/\A(?<x>.)(?<y>.)\z/)
# >>     9    (2.2%)                   |    51  |             x = Position::Hpos.parse(md[:x])
# >>    14    (3.5%)                   |    52  |             y = Position::Vpos.parse(md[:y])
# >>                                   |    53  |           else
# >>                                   |    54  |             raise PointSyntaxError, "座標を2文字で表記していません : #{value.inspect}"
# >>                                   |    55  |           end
# >>                                   |    56  |         else
# >>                                   |    57  |           raise MustNotHappen, "引数が異常です : #{value.inspect}"
# >>                                   |    58  |         end
# >>                                   |    59  | 
# >>     3    (0.7%) /     1   (0.2%)  |    60  |         new(x, y)
# >>                                   |    61  |       end
# >> Bushido::Movabler#movable_infos (/Users/ikeda/src/bushido/lib/bushido/movabler.rb:33)
# >>   samples:     5 self (1.2%)  /    171 total (42.6%)
# >>   callers:
# >>       83  (   48.5%)  Bushido::Movabler#movable_infos
# >>       57  (   33.3%)  Bushido::Runner#execute
# >>       27  (   15.8%)  Set#each
# >>        4  (    2.3%)  Bushido::Battler#movable_infos
# >>   callees (166 total):
# >>       83  (   50.0%)  Bushido::Movabler#movable_infos
# >>       30  (   18.1%)  Bushido::Movabler#piece_store
# >>       28  (   16.9%)  Set#each
# >>        9  (    5.4%)  Bushido::Board::ReaderMethods#lookup
# >>        9  (    5.4%)  Bushido::Point#vector_add
# >>        3  (    1.8%)  Bushido::Point#invalid?
# >>        3  (    1.8%)  Bushido::Player#board
# >>        1  (    0.6%)  Bushido::Piece::VectorMethods#select_vectors
# >>   code:
# >>                                   |    33  |     def movable_infos(player, soldier)
# >>     4    (1.0%) /     4   (1.0%)  |    34  |       Enumerator.new do |yielder|
# >>     1    (0.2%)                   |    35  |         vecs = soldier[:piece].select_vectors(soldier[:promoted])
# >>    56   (14.0%)                   |    36  |         normalized_vectors(soldier[:location], vecs).each do |vec|
# >>                                   |    37  |           pt = soldier[:point]
# >>    55   (13.7%)                   |    38  |           loop do
# >>     9    (2.2%)                   |    39  |             pt = pt.vector_add(vec)
# >>                                   |    40  | 
# >>                                   |    41  |             # 盤外に出てしまったら終わり
# >>     3    (0.7%)                   |    42  |             if pt.invalid?
# >>                                   |    43  |               break
# >>                                   |    44  |             end
# >>                                   |    45  | 
# >>    12    (3.0%)                   |    46  |             target = player.board.lookup(pt)
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
# >>    30    (7.5%)                   |    58  |             piece_store(player, soldier, pt, yielder)
# >>                                   |    59  | 
# >>                                   |    60  |             # 相手駒があるのでこれ以上は進めない
# >>     1    (0.2%) /     1   (0.2%)  |    61  |             if target
# >>                                   |    62  |               break
