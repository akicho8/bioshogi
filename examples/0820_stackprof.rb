require "./example_helper"

# Bushido.config[:skill_set_flag] = false

require "stackprof"

ms = Benchmark.ms do
  StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
    3.times do
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

# system "stackprof stackprof.dump --method Bushido::Point.fetch"
# system "stackprof stackprof.dump --method Bushido::Movabler#movable_infos"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 3797.4 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 707 (0.00% miss rate)
# >>   GC: 83 (11.74%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        447  (63.2%)         100  (14.1%)     Bushido::SkillMonitor#execute
# >>         83  (11.7%)          83  (11.7%)     (garbage collection)
# >>         68   (9.6%)          68   (9.6%)     block (4 levels) in memory_record
# >>         57   (8.1%)          57   (8.1%)     Bushido::Position::Base.lookup
# >>         36   (5.1%)          36   (5.1%)     Bushido::Point#to_xy
# >>         35   (5.0%)          23   (3.3%)     Bushido::Soldier#reverse
# >>         22   (3.1%)          22   (3.1%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         88  (12.4%)          21   (3.0%)     Bushido::Point.lookup
# >>         51   (7.2%)          18   (2.5%)     Bushido::Point#eql?
# >>         17   (2.4%)          16   (2.3%)     ActiveSupport::Inflector#apply_inflections
# >>         37   (5.2%)          15   (2.1%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>         13   (1.8%)          13   (1.8%)     Bushido::Battler#to_soldier
# >>         31   (4.4%)          13   (1.8%)     Bushido::Board::ReaderMethods#lookup
# >>         16   (2.3%)          10   (1.4%)     Bushido::Parser#file_parse
# >>          9   (1.3%)           9   (1.3%)     Bushido::Position::Base.units
# >>          9   (1.3%)           9   (1.3%)     Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>          8   (1.1%)           8   (1.1%)     Bushido::Piece::VectorMethods#select_vectors2
# >>          7   (1.0%)           7   (1.0%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         19   (2.7%)           7   (1.0%)     <top (required)>
# >>         21   (3.0%)           6   (0.8%)     Bushido::Movabler#piece_store
# >>         65   (9.2%)           6   (0.8%)     Bushido::Runner#execute
# >>         20   (2.8%)           6   (0.8%)     Bushido::Position::Hpos.lookup
# >>          6   (0.8%)           6   (0.8%)     Bushido::Point#initialize
# >>         48   (6.8%)           5   (0.7%)     Bushido::Position::Vpos.lookup
# >>          5   (0.7%)           5   (0.7%)     <top (required)>
# >>          5   (0.7%)           5   (0.7%)     Object#present?
# >>          5   (0.7%)           5   (0.7%)     Bushido::HandLog#initialize
# >>        523  (74.0%)           4   (0.6%)     Bushido::Mediator::Executer#execute
# >>          5   (0.7%)           4   (0.6%)     Bushido::Position::Hpos#number_format
# >>          4   (0.6%)           4   (0.6%)     Hash#transform_keys
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:   100 self (14.1%)  /    447 total (63.2%)
# >>   callers:
# >>      596  (  133.3%)  Bushido::SkillMonitor#execute
# >>      447  (  100.0%)  Bushido::Player#execute
# >>      447  (  100.0%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      218  (   48.8%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      208  (   46.5%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>   callees (347 total):
# >>      596  (  171.8%)  Bushido::SkillMonitor#execute
# >>      447  (  128.8%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      218  (   62.8%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      208  (   59.9%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>       68  (   19.6%)  Bushido::AttackInfo#board_parser
# >>       50  (   14.4%)  Bushido::Point#==
# >>       44  (   12.7%)  Bushido::DefenseInfo#board_parser
# >>       30  (    8.6%)  Bushido::SkillMonitor#cached_board_soldiers
# >>       27  (    7.8%)  block (4 levels) in memory_record
# >>       22  (    6.3%)  Bushido::Point#reverse_if_white
# >>       22  (    6.3%)  Bushido::Board::ReaderMethods#[]
# >>       21  (    6.1%)  Bushido::SkillGroupInfo#model
# >>       17  (    4.9%)  Bushido::Soldier#reverse
# >>        9  (    2.6%)  Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>        5  (    1.4%)  Object#presence
# >>        5  (    1.4%)  Bushido::DefenseInfo::AttackInfoSharedMethods#gentei_match_any
# >>        3  (    0.9%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        3  (    0.9%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        3  (    0.9%)  Bushido::Runner#current_soldier
# >>        3  (    0.9%)  Bushido::Runner#before_soldier
# >>        2  (    0.6%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        2  (    0.6%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        2  (    0.6%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        2  (    0.6%)  Bushido::BoardParser::FireBoardParser#trigger_soldiers
# >>        2  (    0.6%)  Bushido::Player#board
# >>        1  (    0.3%)  Bushido::SkillSet#defense_infos
# >>        1  (    0.3%)  Bushido::TurnInfo#senteban_or_goteban
# >>        1  (    0.3%)  Bushido::Piece.fetch
# >>        1  (    0.3%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        1  (    0.3%)  Bushido::DefenseInfo::AttackInfoSharedMethods#gentei_match_any
# >>   code:
# >>                                   |    11  |     def execute
# >>                                   |    12  |       skip = Object.new
# >>   447   (63.2%)                   |    13  |       SkillGroupInfo.each do |group|
# >>                                   |    14  |         list = player.skill_set.public_send(group.var_key)
# >>   447   (63.2%)                   |    15  |         group.model.each do |e|
# >>                                   |    16  |           hit_flag = nil
# >>   426   (60.3%) /     3   (0.4%)  |    17  |           catch skip do
# >>                                   |    18  |             # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>    11    (1.6%) /    11   (1.6%)  |    19  |             if list.include?(e)
# >>                                   |    20  |               throw skip
# >>                                   |    21  |             end
# >>                                   |    22  | 
# >>                                   |    23  |             # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>     7    (1.0%) /     3   (0.4%)  |    24  |             if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    25  |               throw skip
# >>                                   |    26  |             end
# >>                                   |    27  | 
# >>     3    (0.4%)                   |    28  |             if e.turn_limit
# >>     1    (0.1%) /     1   (0.1%)  |    29  |               if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    30  |                 throw skip
# >>                                   |    31  |               end
# >>                                   |    32  |             end
# >>                                   |    33  | 
# >>     2    (0.3%)                   |    34  |             if e.turn_eq
# >>                                   |    35  |               if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    36  |                 throw skip
# >>                                   |    37  |               end
# >>                                   |    38  |             end
# >>                                   |    39  | 
# >>     5    (0.7%)                   |    40  |             if e.teban_eq
# >>     1    (0.1%)                   |    41  |               if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
# >>                                   |    42  |                 throw skip
# >>                                   |    43  |               end
# >>                                   |    44  |             end
# >>                                   |    45  | 
# >>     3    (0.4%)                   |    46  |             if e.kaisenmae
# >>                                   |    47  |               if player.mediator.kill_counter.positive?
# >>                                   |    48  |                 throw skip
# >>                                   |    49  |               end
# >>                                   |    50  |             end
# >>                                   |    51  | 
# >>     1    (0.1%)                   |    52  |             if e.stroke_only
# >>                                   |    53  |               if player.runner.before_soldier
# >>                                   |    54  |                 throw skip
# >>                                   |    55  |               end
# >>                                   |    56  |             end
# >>                                   |    57  | 
# >>     6    (0.8%)                   |    58  |             if e.kill_only
# >>                                   |    59  |               unless player.runner.tottakoma
# >>                                   |    60  |                 throw skip
# >>                                   |    61  |               end
# >>                                   |    62  |             end
# >>                                   |    63  | 
# >>                                   |    64  |             if v = e.hold_piece_count_eq
# >>                                   |    65  |               if player.pieces.size != v
# >>                                   |    66  |                 throw skip
# >>                                   |    67  |               end
# >>                                   |    68  |             end
# >>                                   |    69  | 
# >>                                   |    70  |             # 何もない
# >>    73   (10.3%) /     2   (0.3%)  |    71  |             if ary = e.board_parser.other_objects_hash_ary["○"]
# >>    40    (5.7%)                   |    72  |               ary.each do |obj|
# >>    16    (2.3%)                   |    73  |                 pt = obj[:point].reverse_if_white(player.location)
# >>    24    (3.4%)                   |    74  |                 if player.board[pt]
# >>                                   |    75  |                   throw skip
# >>                                   |    76  |                 end
# >>                                   |    77  |               end
# >>                                   |    78  |             end
# >>                                   |    79  | 
# >>                                   |    80  |             # 何かある
# >>    10    (1.4%) /     2   (0.3%)  |    81  |             if ary = e.board_parser.other_objects_hash_ary["●"]
# >>                                   |    82  |               ary.each do |obj|
# >>                                   |    83  |                 pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    84  |                 if !player.board[pt]
# >>                                   |    85  |                   throw skip
# >>                                   |    86  |                 end
# >>                                   |    87  |               end
# >>                                   |    88  |             end
# >>                                   |    89  | 
# >>                                   |    90  |             # 移動元ではない
# >>    16    (2.3%)                   |    91  |             if ary = e.board_parser.other_objects_hash_ary["☆"]
# >>                                   |    92  |               ary.each do |obj|
# >>                                   |    93  |                 pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    94  |                 before_soldier = player.runner.before_soldier
# >>                                   |    95  |                 if before_soldier && pt == before_soldier.point
# >>                                   |    96  |                   throw skip
# >>                                   |    97  |                 end
# >>                                   |    98  |               end
# >>                                   |    99  |             end
# >>                                   |   100  | 
# >>                                   |   101  |             # 移動元(any条件)
# >>    12    (1.7%)                   |   102  |             ary = e.board_parser.other_objects_hash_ary["★"]
# >>                                   |   103  |             if ary.present?
# >>     3    (0.4%)                   |   104  |               before_soldier = player.runner.before_soldier
# >>                                   |   105  |               if !before_soldier
# >>                                   |   106  |                 # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   107  |                 throw skip
# >>                                   |   108  |               end
# >>     7    (1.0%)                   |   109  |               if ary.any? { |e|
# >>     6    (0.8%)                   |   110  |                   pt = e[:point].reverse_if_white(player.location)
# >>     1    (0.1%)                   |   111  |                   pt == before_soldier.point
# >>                                   |   112  |                 }
# >>                                   |   113  |               else
# >>                                   |   114  |                 throw skip
# >>                                   |   115  |               end
# >>                                   |   116  |             end
# >>                                   |   117  | 
# >>     4    (0.6%)                   |   118  |             if e.fuganai
# >>     1    (0.1%)                   |   119  |               if player.pieces.include?(Piece.fetch(:pawn))
# >>                                   |   120  |                 throw skip
# >>                                   |   121  |               end
# >>                                   |   122  |             end
# >>                                   |   123  | 
# >>     2    (0.3%)                   |   124  |             if e.fu_igai_mottetara_dame
# >>                                   |   125  |               unless (player.pieces - [Piece.fetch(:pawn)]).empty?
# >>                                   |   126  |                 throw skip
# >>                                   |   127  |               end
# >>                                   |   128  |             end
# >>                                   |   129  | 
# >>     4    (0.6%)                   |   130  |             if v = e.hold_piece_eq
# >>                                   |   131  |               if player.pieces.sort != v.sort
# >>                                   |   132  |                 throw skip
# >>                                   |   133  |               end
# >>                                   |   134  |             end
# >>                                   |   135  | 
# >>     2    (0.3%)                   |   136  |             if v = e.hold_piece_in
# >>                                   |   137  |               unless v.all? {|x| player.pieces.include?(x) }
# >>                                   |   138  |                 throw skip
# >>                                   |   139  |               end
# >>                                   |   140  |             end
# >>                                   |   141  | 
# >>     1    (0.1%) /     1   (0.1%)  |   142  |             if v = e.hold_piece_not_in
# >>                                   |   143  |               if v.any? {|x| player.pieces.include?(x) }
# >>                                   |   144  |                 throw skip
# >>                                   |   145  |               end
# >>                                   |   146  |             end
# >>                                   |   147  | 
# >>     4    (0.6%)                   |   148  |             if v = e.triggers
# >>                                   |   149  |               current_soldier = player.runner.current_soldier
# >>                                   |   150  |               if player.location.key == :white
# >>                                   |   151  |                 current_soldier = current_soldier.reverse
# >>                                   |   152  |               end
# >>                                   |   153  |               v.each do |soldier|
# >>                                   |   154  |                 if current_soldier != soldier
# >>                                   |   155  |                   throw skip
# >>                                   |   156  |                 end
# >>                                   |   157  |               end
# >>                                   |   158  |             end
# >>                                   |   159  | 
# >>                                   |   160  |             # ここは位置のハッシュを作っておくのがいいかもしれん
# >>    13    (1.8%)                   |   161  |             if v = e.board_parser.trigger_soldiers.presence
# >>     3    (0.4%)                   |   162  |               current_soldier = player.runner.current_soldier
# >>     1    (0.1%)                   |   163  |               if player.location.key == :white
# >>    17    (2.4%)                   |   164  |                 current_soldier = current_soldier.reverse
# >>                                   |   165  |               end
# >>     2    (0.3%)                   |   166  |               v.each do |soldier|
# >>     2    (0.3%) /     1   (0.1%)  |   167  |                 if current_soldier != soldier
# >>                                   |   168  |                   throw skip
# >>                                   |   169  |                 end
# >>                                   |   170  |               end
# >>                                   |   171  |             end
# >>                                   |   172  | 
# >>    30    (4.2%)                   |   173  |             soldiers = cached_board_soldiers(e)
# >>                                   |   174  | 
# >>                                   |   175  |             # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
# >>     6    (0.8%)                   |   176  |             if v = e.gentei_match_any
# >>                                   |   177  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   178  |               else
# >>                                   |   179  |                 throw skip
# >>                                   |   180  |               end
# >>                                   |   181  |             end
# >>                                   |   182  | 
# >>                                   |   183  |             # どれかが盤上に含まれる
# >>     6    (0.8%)                   |   184  |             if v = e.board_parser.any_exist_soldiers.presence
# >>                                   |   185  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   186  |               else
# >>                                   |   187  |                 throw skip
# >>                                   |   188  |               end
# >>                                   |   189  |             end
# >>                                   |   190  | 
# >>   249   (35.2%) /    76  (10.7%)  |   191  |             if e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
# >>                                   |   192  |               list << e
# >>     1    (0.1%)                   |   193  |               player.runner.skill_set.public_send(group.var_key) << e
# >>                                   |   194  |             end
