require "./example_helper"

# Bushido.config[:skill_set_flag] = false

require "stackprof"

ms = Benchmark.ms do
  StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
    10.times do
      ["csa", "ki2", "kif", "sfen"].each do |e|
        info = Parser.file_parse("katomomo.#{e}")
        info.to_ki2
        info.to_kif
        info.to_csa
        info.to_sfen
      end
    end
  end
end

puts "%.1f ms" % ms

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Bushido::SkillMonitor#execute"
system "stackprof stackprof.dump --method Bushido::Position::Base.lookup"

# system "stackprof stackprof.dump --method Bushido::Point.fetch"
# system "stackprof stackprof.dump --method Bushido::Movabler#movable_infos"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 3852.6 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 1714 (0.00% miss rate)
# >>   GC: 326 (19.02%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        326  (19.0%)         326  (19.0%)     (garbage collection)
# >>        133   (7.8%)         130   (7.6%)     Bushido::Position::Base.lookup
# >>         80   (4.7%)          80   (4.7%)     block (4 levels) in memory_record
# >>         65   (3.8%)          65   (3.8%)     Bushido::Point#to_xy
# >>        235  (13.7%)          61   (3.6%)     Bushido::Point.lookup
# >>         57   (3.3%)          57   (3.3%)     Bushido::Battler#to_soldier
# >>        243  (14.2%)          56   (3.3%)     Bushido::SkillMonitor#execute_one
# >>         44   (2.6%)          44   (2.6%)     Hash#slice
# >>        140   (8.2%)          40   (2.3%)     Bushido::Movabler#piece_store
# >>         38   (2.2%)          38   (2.2%)     Bushido::Piece::VectorMethods#select_vectors2
# >>        513  (29.9%)          33   (1.9%)     Bushido::Runner#execute
# >>         87   (5.1%)          31   (1.8%)     Bushido::Soldier#reverse
# >>         28   (1.6%)          28   (1.6%)     Bushido::Position::Base.units
# >>         54   (3.2%)          27   (1.6%)     Bushido::Parser#file_parse
# >>         29   (1.7%)          24   (1.4%)     Hash#transform_keys
# >>         22   (1.3%)          22   (1.3%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         21   (1.2%)          21   (1.2%)     Bushido::HandLog#initialize
# >>         95   (5.5%)          21   (1.2%)     Bushido::Position::Hpos.lookup
# >>         21   (1.2%)          21   (1.2%)     Bushido::Position::Base.value_range
# >>         20   (1.2%)          20   (1.2%)     #<Module:0x007ffdc2ac6e90>.kconv
# >>         24   (1.4%)          19   (1.1%)     ActiveSupport::Duration::Scalar#-
# >>         41   (2.4%)          18   (1.1%)     Bushido::Point#hash
# >>         17   (1.0%)          17   (1.0%)     Bushido::Point#initialize
# >>         37   (2.2%)          16   (0.9%)     Bushido::Position::Base#valid?
# >>         20   (1.2%)          15   (0.9%)     Bushido::Position::Vpos#number_format
# >>         26   (1.5%)          15   (0.9%)     Bushido::Piece::NameMethods#basic_names
# >>        261  (15.2%)          13   (0.8%)     Bushido::Movabler#movable_infos
# >>         13   (0.8%)          13   (0.8%)     Bushido::Parser::Base::ConverterMethods#mb_ljust
# >>         76   (4.4%)          12   (0.7%)     Bushido::Position::Vpos.lookup
# >>         20   (1.2%)          12   (0.7%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >> Bushido::SkillMonitor#execute_one (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:21)
# >>   samples:    56 self (3.3%)  /    243 total (14.2%)
# >>   callers:
# >>      319  (  131.3%)  Bushido::SkillMonitor#execute_one
# >>      243  (  100.0%)  Bushido::SkillMonitor#execute
# >>   callees (187 total):
# >>      319  (  170.6%)  Bushido::SkillMonitor#execute_one
# >>       98  (   52.4%)  Bushido::SkillMonitor#on_board_soldiers
# >>       16  (    8.6%)  Bushido::AttackInfo#board_parser
# >>       14  (    7.5%)  Bushido::DefenseInfo#board_parser
# >>       11  (    5.9%)  Bushido::Point#==
# >>        8  (    4.3%)  Bushido::Point#reverse_if_white
# >>        6  (    3.2%)  Bushido::Board::ReaderMethods#[]
# >>        5  (    2.7%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        4  (    2.1%)  Bushido::TacticInfo#var_key
# >>        4  (    2.1%)  Bushido::Point#eql?
# >>        2  (    1.1%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        2  (    1.1%)  Bushido::SkillSet#attack_infos
# >>        2  (    1.1%)  Bushido::SkillSet#defense_infos
# >>        2  (    1.1%)  Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>        2  (    1.1%)  Bushido::Player#board
# >>        2  (    1.1%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        2  (    1.1%)  Object#present?
# >>        2  (    1.1%)  block (4 levels) in memory_record
# >>        1  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        1  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        1  (    0.5%)  Bushido::Point#hash
# >>        1  (    0.5%)  Bushido::BoardParser::FireBoardParser#trigger_soldiers_hash
# >>        1  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>   code:
# >>                                   |    21  |     def execute_one(e)
# >>   243   (14.2%) /     2   (0.1%)  |    22  |       catch :skip do
# >>    16    (0.9%)                   |    23  |         if v = e.board_parser.trigger_soldiers_hash.presence
# >>                                   |    24  |           # トリガー駒が用意されているのに、その座標に移動先が含まれていなかったら即座に skip
# >>     5    (0.3%)                   |    25  |           soldier = v[current_soldier[:point]]
# >>                                   |    26  |           unless soldier
# >>                                   |    27  |             throw :skip
# >>                                   |    28  |           end
# >>                                   |    29  |           # 駒や状態まで判定する
# >>     1    (0.1%) /     1   (0.1%)  |    30  |           if soldier != current_soldier
# >>                                   |    31  |             throw :skip
# >>                                   |    32  |           end
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>                                   |    35  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>    15    (0.9%)                   |    36  |         list = player.skill_set.public_send(e.tactic_info.var_key)
# >>                                   |    37  |         if list.include?(e)
# >>                                   |    38  |           throw :skip
# >>                                   |    39  |         end
# >>                                   |    40  | 
# >>                                   |    41  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>     3    (0.2%)                   |    42  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    43  |           throw :skip
# >>                                   |    44  |         end
# >>                                   |    45  | 
# >>                                   |    46  |         if e.turn_limit
# >>                                   |    47  |           if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    48  |             throw :skip
# >>                                   |    49  |           end
# >>                                   |    50  |         end
# >>                                   |    51  | 
# >>     1    (0.1%) /     1   (0.1%)  |    52  |         if e.turn_eq
# >>                                   |    53  |           if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    54  |             throw :skip
# >>                                   |    55  |           end
# >>                                   |    56  |         end
# >>                                   |    57  | 
# >>                                   |    58  |         if e.teban_eq
# >>                                   |    59  |           if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
# >>                                   |    60  |             throw :skip
# >>                                   |    61  |           end
# >>                                   |    62  |         end
# >>                                   |    63  | 
# >>     1    (0.1%)                   |    64  |         if e.kaisenmae
# >>                                   |    65  |           if player.mediator.kill_counter.positive?
# >>                                   |    66  |             throw :skip
# >>                                   |    67  |           end
# >>                                   |    68  |         end
# >>                                   |    69  | 
# >>                                   |    70  |         if e.stroke_only
# >>                                   |    71  |           if player.runner.before_soldier
# >>                                   |    72  |             throw :skip
# >>                                   |    73  |           end
# >>                                   |    74  |         end
# >>                                   |    75  | 
# >>                                   |    76  |         if e.kill_only
# >>                                   |    77  |           unless player.runner.tottakoma
# >>                                   |    78  |             throw :skip
# >>                                   |    79  |           end
# >>                                   |    80  |         end
# >>                                   |    81  | 
# >>                                   |    82  |         if v = e.hold_piece_count_eq
# >>                                   |    83  |           if player.pieces.size != v
# >>                                   |    84  |             throw :skip
# >>                                   |    85  |           end
# >>                                   |    86  |         end
# >>                                   |    87  | 
# >>                                   |    88  |         # 何もない
# >>     7    (0.4%) /     1   (0.1%)  |    89  |         if ary = e.board_parser.other_objects_hash_ary["○"]
# >>    17    (1.0%)                   |    90  |           ary.each do |obj|
# >>     8    (0.5%)                   |    91  |             pt = obj[:point].reverse_if_white(player.location)
# >>     9    (0.5%) /     1   (0.1%)  |    92  |             if player.board[pt]
# >>                                   |    93  |               throw :skip
# >>                                   |    94  |             end
# >>                                   |    95  |           end
# >>                                   |    96  |         end
# >>                                   |    97  | 
# >>                                   |    98  |         # 何かある
# >>     2    (0.1%)                   |    99  |         if ary = e.board_parser.other_objects_hash_ary["●"]
# >>                                   |   100  |           ary.each do |obj|
# >>                                   |   101  |             pt = obj[:point].reverse_if_white(player.location)
# >>                                   |   102  |             if !player.board[pt]
# >>                                   |   103  |               throw :skip
# >>                                   |   104  |             end
# >>                                   |   105  |           end
# >>                                   |   106  |         end
# >>                                   |   107  | 
# >>                                   |   108  |         # 移動元ではない
# >>     5    (0.3%)                   |   109  |         if ary = e.board_parser.other_objects_hash_ary["☆"]
# >>                                   |   110  |           ary.each do |obj|
# >>                                   |   111  |             pt = obj[:point].reverse_if_white(player.location)
# >>                                   |   112  |             before_soldier = player.runner.before_soldier
# >>                                   |   113  |             if before_soldier && pt == before_soldier.point
# >>                                   |   114  |               throw :skip
# >>                                   |   115  |             end
# >>                                   |   116  |           end
# >>                                   |   117  |         end
# >>                                   |   118  | 
# >>                                   |   119  |         # 移動元(any条件)
# >>     1    (0.1%)                   |   120  |         ary = e.board_parser.other_objects_hash_ary["★"]
# >>     2    (0.1%)                   |   121  |         if ary.present?
# >>                                   |   122  |           before_soldier = player.runner.before_soldier
# >>                                   |   123  |           if !before_soldier
# >>                                   |   124  |             # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   125  |             throw :skip
# >>                                   |   126  |           end
# >>     1    (0.1%)                   |   127  |           if ary.any? { |e|
# >>                                   |   128  |               pt = e[:point].reverse_if_white(player.location)
# >>     1    (0.1%)                   |   129  |               pt == before_soldier.point
# >>                                   |   130  |             }
# >>                                   |   131  |           else
# >>                                   |   132  |             throw :skip
# >>                                   |   133  |           end
# >>                                   |   134  |         end
# >>                                   |   135  | 
# >>     1    (0.1%)                   |   136  |         if e.fuganai
# >>                                   |   137  |           if player.pieces.include?(Piece.fetch(:pawn))
# >>                                   |   138  |             throw :skip
# >>                                   |   139  |           end
# >>                                   |   140  |         end
# >>                                   |   141  | 
# >>                                   |   142  |         if e.fu_igai_mottetara_dame
# >>                                   |   143  |           unless (player.pieces - [Piece.fetch(:pawn)]).empty?
# >>                                   |   144  |             throw :skip
# >>                                   |   145  |           end
# >>                                   |   146  |         end
# >>                                   |   147  | 
# >>     1    (0.1%)                   |   148  |         if v = e.hold_piece_eq
# >>                                   |   149  |           if player.pieces.sort != v.sort
# >>                                   |   150  |             throw :skip
# >>                                   |   151  |           end
# >>                                   |   152  |         end
# >>                                   |   153  | 
# >>                                   |   154  |         if v = e.hold_piece_in
# >>                                   |   155  |           unless v.all? {|x| player.pieces.include?(x) }
# >>                                   |   156  |             throw :skip
# >>                                   |   157  |           end
# >>                                   |   158  |         end
# >>                                   |   159  | 
# >>     1    (0.1%)                   |   160  |         if v = e.hold_piece_not_in
# >>                                   |   161  |           if v.any? {|x| player.pieces.include?(x) }
# >>                                   |   162  |             throw :skip
# >>                                   |   163  |           end
# >>                                   |   164  |         end
# >>                                   |   165  | 
# >>    98    (5.7%)                   |   166  |         soldiers = on_board_soldiers(e)
# >>                                   |   167  | 
# >>                                   |   168  |         # どれかが盤上に含まれる
# >>                                   |   169  |         if v = e.board_parser.any_exist_soldiers.presence
# >>     8    (0.5%) /     4   (0.2%)  |   170  |           if v.any? {|o| soldiers.include?(o) }
# >>                                   |   171  |           else
# >>                                   |   172  |             throw :skip
# >>                                   |   173  |           end
# >>                                   |   174  |         end
# >>                                   |   175  | 
# >>   115    (6.7%) /    46   (2.7%)  |   176  |         if e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
# >>                                   |   177  |           list << e
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:     6 self (0.4%)  /    336 total (19.6%)
# >>   callers:
# >>      336  (  100.0%)  Bushido::Player#execute
# >>      243  (   72.3%)  Bushido::SkillMonitor#execute
# >>   callees (330 total):
# >>      243  (   73.6%)  Bushido::SkillMonitor#execute_one
# >>      243  (   73.6%)  Bushido::SkillMonitor#execute
# >>       75  (   22.7%)  Bushido::TacticInfo.all_soldier_points_hash
# >>        8  (    2.4%)  Bushido::SkillMonitor#current_soldier
# >>        2  (    0.6%)  Bushido::Point#hash
# >>        2  (    0.6%)  Bushido::Point#eql?
# >>   code:
# >>                                   |    11  |     def execute
# >>                                   |    12  |       # すべての戦法と比べるのではなく移動先に駒を持つ戦法だけに絞る
# >>    93    (5.4%) /     6   (0.4%)  |    13  |       elements = TacticInfo.all_soldier_points_hash[current_soldier]
# >>                                   |    14  |       unless elements
# >>                                   |    15  |         return
# >>                                   |    16  |       end
# >>                                   |    17  | 
# >>   486   (28.4%)                   |    18  |       elements.each { |e| execute_one(e) }
# >>                                   |    19  |     end
# >> Bushido::Position::Base.lookup (/Users/ikeda/src/bushido/lib/bushido/position.rb:73)
# >>   samples:   130 self (7.6%)  /    133 total (7.8%)
# >>   callers:
# >>       74  (   55.6%)  Bushido::Position::Hpos.lookup
# >>       59  (   44.4%)  Bushido::Position::Vpos.lookup
# >>   callees (3 total):
# >>        3  (  100.0%)  Bushido::Position::Base.units_set
# >>   code:
# >>                                   |    73  |         def lookup(value)
# >>    91    (5.3%) /    91   (5.3%)  |    74  |           if value.kind_of?(Base)
# >>     8    (0.5%) /     8   (0.5%)  |    75  |             return value
# >>                                   |    76  |           end
# >>     2    (0.1%) /     2   (0.1%)  |    77  |           if value.kind_of?(String)
# >>     3    (0.2%)                   |    78  |             value = units_set[value]
# >>                                   |    79  |           end
# >>     1    (0.1%) /     1   (0.1%)  |    80  |           if value
# >>    11    (0.6%) /    11   (0.6%)  |    81  |             @instance ||= {}
# >>    17    (1.0%) /    17   (1.0%)  |    82  |             @instance[value] ||= new(value).freeze
# >>                                   |    83  |           end
