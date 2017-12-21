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

# >> 4024.8 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 821 (0.00% miss rate)
# >>   GC: 92 (11.21%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        532  (64.8%)         119  (14.5%)     Bushido::SkillMonitor#execute
# >>         92  (11.2%)          92  (11.2%)     (garbage collection)
# >>         81   (9.9%)          81   (9.9%)     block (4 levels) in memory_record
# >>         81   (9.9%)          80   (9.7%)     Bushido::Position::Base.lookup
# >>         51   (6.2%)          27   (3.3%)     Bushido::Point#eql?
# >>         27   (3.3%)          27   (3.3%)     Bushido::Point#to_xy
# >>        121  (14.7%)          25   (3.0%)     Bushido::Point.lookup
# >>         47   (5.7%)          24   (2.9%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>         23   (2.8%)          23   (2.8%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         20   (2.4%)          18   (2.2%)     ActiveSupport::Inflector#apply_inflections
# >>         28   (3.4%)          15   (1.8%)     Bushido::Soldier#reverse
# >>         14   (1.7%)          14   (1.7%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         12   (1.5%)          12   (1.5%)     Bushido::Battler#to_soldier
# >>         10   (1.2%)          10   (1.2%)     Bushido::Position::Base.units
# >>         21   (2.6%)          10   (1.2%)     Bushido::Movabler#piece_store
# >>         16   (1.9%)          10   (1.2%)     Bushido::Parser#file_parse
# >>         10   (1.2%)          10   (1.2%)     Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>         97  (11.8%)          10   (1.2%)     Bushido::ShapeInfo#board_parser
# >>         45   (5.5%)           9   (1.1%)     Bushido::Position::Vpos.lookup
# >>          8   (1.0%)           8   (1.0%)     Bushido::Point#initialize
# >>          8   (1.0%)           8   (1.0%)     Bushido::Point#to_a
# >>          8   (1.0%)           8   (1.0%)     Hash#slice
# >>          7   (0.9%)           7   (0.9%)     Bushido::Position::Hpos#number_format
# >>          6   (0.7%)           6   (0.7%)     Bushido::Position::Vpos#number_format
# >>          6   (0.7%)           6   (0.7%)     Bushido::Runner#current_soldier
# >>         18   (2.2%)           6   (0.7%)     <top (required)>
# >>         51   (6.2%)           6   (0.7%)     Bushido::Position::Hpos.lookup
# >>          5   (0.6%)           5   (0.6%)     Bushido::HandLog#initialize
# >>          5   (0.6%)           5   (0.6%)     Hash#assert_valid_keys
# >>          6   (0.7%)           4   (0.5%)     ActiveSupport::Inflector#inflections
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:   119 self (14.5%)  /    532 total (64.8%)
# >>   callers:
# >>      687  (  129.1%)  Bushido::SkillMonitor#execute
# >>      532  (  100.0%)  Bushido::Player#execute
# >>      532  (  100.0%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      274  (   51.5%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      226  (   42.5%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>   callees (413 total):
# >>      687  (  166.3%)  Bushido::SkillMonitor#execute
# >>      532  (  128.8%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      274  (   66.3%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      226  (   54.7%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>       99  (   24.0%)  Bushido::AttackInfo#board_parser
# >>       59  (   14.3%)  Bushido::DefenseInfo#board_parser
# >>       45  (   10.9%)  Bushido::Point#==
# >>       38  (    9.2%)  block (4 levels) in memory_record
# >>       33  (    8.0%)  Bushido::Point#reverse_if_white
# >>       32  (    7.7%)  Bushido::TacticInfo#model
# >>       26  (    6.3%)  Bushido::Board::ReaderMethods#[]
# >>       26  (    6.3%)  Bushido::SkillMonitor#cached_board_soldiers
# >>       10  (    2.4%)  Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>        8  (    1.9%)  Bushido::Soldier#reverse
# >>        5  (    1.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        4  (    1.0%)  Bushido::Runner#current_soldier
# >>        4  (    1.0%)  Object#present?
# >>        4  (    1.0%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        4  (    1.0%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        3  (    0.7%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        3  (    0.7%)  Object#presence
# >>        2  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        1  (    0.2%)  Bushido::Runner#before_soldier
# >>        1  (    0.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        1  (    0.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        1  (    0.2%)  Bushido::BoardParser::Base#soldiers
# >>        1  (    0.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        1  (    0.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        1  (    0.2%)  Bushido::Piece.fetch
# >>        1  (    0.2%)  Bushido::BoardParser::FireBoardParser#trigger_soldiers
# >>   code:
# >>                                   |    11  |     def execute
# >>                                   |    12  |       skip = Object.new
# >>   532   (64.8%)                   |    13  |       TacticInfo.each do |group|
# >>                                   |    14  |         list = player.skill_set.public_send(group.var_key)
# >>   532   (64.8%)                   |    15  |         group.model.each do |e|
# >>                                   |    16  |           hit_flag = nil
# >>   500   (60.9%) /     7   (0.9%)  |    17  |           catch skip do
# >>                                   |    18  |             # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     6    (0.7%) /     6   (0.7%)  |    19  |             if list.include?(e)
# >>                                   |    20  |               throw skip
# >>                                   |    21  |             end
# >>                                   |    22  | 
# >>                                   |    23  |             # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>     7    (0.9%) /     2   (0.2%)  |    24  |             if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    25  |               throw skip
# >>                                   |    26  |             end
# >>                                   |    27  | 
# >>     7    (0.9%)                   |    28  |             if e.turn_limit
# >>                                   |    29  |               if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    30  |                 throw skip
# >>                                   |    31  |               end
# >>                                   |    32  |             end
# >>                                   |    33  | 
# >>     7    (0.9%) /     1   (0.1%)  |    34  |             if e.turn_eq
# >>                                   |    35  |               if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    36  |                 throw skip
# >>                                   |    37  |               end
# >>                                   |    38  |             end
# >>                                   |    39  | 
# >>     4    (0.5%)                   |    40  |             if e.teban_eq
# >>                                   |    41  |               if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
# >>                                   |    42  |                 throw skip
# >>                                   |    43  |               end
# >>                                   |    44  |             end
# >>                                   |    45  | 
# >>     3    (0.4%)                   |    46  |             if e.kaisenmae
# >>     1    (0.1%) /     1   (0.1%)  |    47  |               if player.mediator.kill_counter.positive?
# >>                                   |    48  |                 throw skip
# >>                                   |    49  |               end
# >>                                   |    50  |             end
# >>                                   |    51  | 
# >>     5    (0.6%) /     1   (0.1%)  |    52  |             if e.stroke_only
# >>                                   |    53  |               if player.runner.before_soldier
# >>                                   |    54  |                 throw skip
# >>                                   |    55  |               end
# >>                                   |    56  |             end
# >>                                   |    57  | 
# >>     5    (0.6%) /     1   (0.1%)  |    58  |             if e.kill_only
# >>                                   |    59  |               unless player.runner.tottakoma
# >>                                   |    60  |                 throw skip
# >>                                   |    61  |               end
# >>                                   |    62  |             end
# >>                                   |    63  | 
# >>     3    (0.4%)                   |    64  |             if v = e.hold_piece_count_eq
# >>                                   |    65  |               if player.pieces.size != v
# >>                                   |    66  |                 throw skip
# >>                                   |    67  |               end
# >>                                   |    68  |             end
# >>                                   |    69  | 
# >>                                   |    70  |             # 何もない
# >>   105   (12.8%)                   |    71  |             if ary = e.board_parser.other_objects_hash_ary["○"]
# >>    52    (6.3%)                   |    72  |               ary.each do |obj|
# >>    26    (3.2%)                   |    73  |                 pt = obj[:point].reverse_if_white(player.location)
# >>    26    (3.2%)                   |    74  |                 if player.board[pt]
# >>                                   |    75  |                   throw skip
# >>                                   |    76  |                 end
# >>                                   |    77  |               end
# >>                                   |    78  |             end
# >>                                   |    79  | 
# >>                                   |    80  |             # 何かある
# >>    18    (2.2%)                   |    81  |             if ary = e.board_parser.other_objects_hash_ary["●"]
# >>                                   |    82  |               ary.each do |obj|
# >>                                   |    83  |                 pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    84  |                 if !player.board[pt]
# >>                                   |    85  |                   throw skip
# >>                                   |    86  |                 end
# >>                                   |    87  |               end
# >>                                   |    88  |             end
# >>                                   |    89  | 
# >>                                   |    90  |             # 移動元ではない
# >>    14    (1.7%) /     2   (0.2%)  |    91  |             if ary = e.board_parser.other_objects_hash_ary["☆"]
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
# >>    13    (1.6%)                   |   102  |             ary = e.board_parser.other_objects_hash_ary["★"]
# >>     5    (0.6%) /     1   (0.1%)  |   103  |             if ary.present?
# >>     1    (0.1%)                   |   104  |               before_soldier = player.runner.before_soldier
# >>     1    (0.1%) /     1   (0.1%)  |   105  |               if !before_soldier
# >>                                   |   106  |                 # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   107  |                 throw skip
# >>                                   |   108  |               end
# >>    12    (1.5%)                   |   109  |               if ary.any? { |e|
# >>     7    (0.9%)                   |   110  |                   pt = e[:point].reverse_if_white(player.location)
# >>     5    (0.6%)                   |   111  |                   pt == before_soldier.point
# >>                                   |   112  |                 }
# >>                                   |   113  |               else
# >>                                   |   114  |                 throw skip
# >>                                   |   115  |               end
# >>                                   |   116  |             end
# >>                                   |   117  | 
# >>     3    (0.4%)                   |   118  |             if e.fuganai
# >>     1    (0.1%)                   |   119  |               if player.pieces.include?(Piece.fetch(:pawn))
# >>                                   |   120  |                 throw skip
# >>                                   |   121  |               end
# >>                                   |   122  |             end
# >>                                   |   123  | 
# >>     2    (0.2%)                   |   124  |             if e.fu_igai_mottetara_dame
# >>     1    (0.1%) /     1   (0.1%)  |   125  |               unless (player.pieces - [Piece.fetch(:pawn)]).empty?
# >>                                   |   126  |                 throw skip
# >>                                   |   127  |               end
# >>                                   |   128  |             end
# >>                                   |   129  | 
# >>     5    (0.6%)                   |   130  |             if v = e.hold_piece_eq
# >>     3    (0.4%) /     3   (0.4%)  |   131  |               if player.pieces.sort != v.sort
# >>                                   |   132  |                 throw skip
# >>                                   |   133  |               end
# >>                                   |   134  |             end
# >>                                   |   135  | 
# >>     1    (0.1%)                   |   136  |             if v = e.hold_piece_in
# >>                                   |   137  |               unless v.all? {|x| player.pieces.include?(x) }
# >>                                   |   138  |                 throw skip
# >>                                   |   139  |               end
# >>                                   |   140  |             end
# >>                                   |   141  | 
# >>     6    (0.7%)                   |   142  |             if v = e.hold_piece_not_in
# >>                                   |   143  |               if v.any? {|x| player.pieces.include?(x) }
# >>                                   |   144  |                 throw skip
# >>                                   |   145  |               end
# >>                                   |   146  |             end
# >>                                   |   147  | 
# >>     5    (0.6%)                   |   148  |             if v = e.triggers
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
# >>     9    (1.1%)                   |   161  |             if v = e.board_parser.trigger_soldiers.presence
# >>     4    (0.5%)                   |   162  |               current_soldier = player.runner.current_soldier
# >>     2    (0.2%)                   |   163  |               if player.location.key == :white
# >>     8    (1.0%)                   |   164  |                 current_soldier = current_soldier.reverse
# >>                                   |   165  |               end
# >>     1    (0.1%)                   |   166  |               v.each do |soldier|
# >>     1    (0.1%)                   |   167  |                 if current_soldier != soldier
# >>                                   |   168  |                   throw skip
# >>                                   |   169  |                 end
# >>                                   |   170  |               end
# >>                                   |   171  |             end
# >>                                   |   172  | 
# >>    26    (3.2%)                   |   173  |             soldiers = cached_board_soldiers(e)
# >>                                   |   174  | 
# >>                                   |   175  |             # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
# >>                                   |   176  |             if v = e.gentei_match_any
# >>                                   |   177  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   178  |               else
# >>                                   |   179  |                 throw skip
# >>                                   |   180  |               end
# >>                                   |   181  |             end
# >>                                   |   182  | 
# >>                                   |   183  |             # どれかが盤上に含まれる
# >>     8    (1.0%)                   |   184  |             if v = e.board_parser.any_exist_soldiers.presence
# >>                                   |   185  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   186  |               else
# >>                                   |   187  |                 throw skip
# >>                                   |   188  |               end
# >>                                   |   189  |             end
# >>                                   |   190  | 
# >>   267   (32.5%) /    91  (11.1%)  |   191  |             if e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
# >>                                   |   192  |               list << e
# >>     1    (0.1%) /     1   (0.1%)  |   193  |               player.runner.skill_set.public_send(group.var_key) << e
# >>                                   |   194  |             end
