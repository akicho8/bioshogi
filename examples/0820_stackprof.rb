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

# >> 4044.2 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 739 (0.00% miss rate)
# >>   GC: 94 (12.72%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>         94  (12.7%)          94  (12.7%)     (garbage collection)
# >>         70   (9.5%)          70   (9.5%)     block (4 levels) in memory_record
# >>        484  (65.5%)          67   (9.1%)     Bushido::SkillMonitor#execute
# >>         54   (7.3%)          54   (7.3%)     Bushido::Position::Base.lookup
# >>         52   (7.0%)          34   (4.6%)     Bushido::Utils#hold_pieces_s_to_a
# >>         25   (3.4%)          25   (3.4%)     Bushido::Point#to_xy
# >>         76  (10.3%)          24   (3.2%)     Bushido::SkillMonitor#cached_soldiers
# >>         42   (5.7%)          24   (3.2%)     Bushido::Soldier#reverse
# >>         22   (3.0%)          22   (3.0%)     Bushido::Battler#to_soldier
# >>         40   (5.4%)          21   (2.8%)     Bushido::Board::ReaderMethods#lookup
# >>         81  (11.0%)          20   (2.7%)     Bushido::Point.lookup
# >>         27   (3.7%)          17   (2.3%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>         12   (1.6%)          12   (1.6%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         11   (1.5%)          11   (1.5%)     Bushido::Runner#current_soldier
# >>         17   (2.3%)          11   (1.5%)     Bushido::Parser#file_parse
# >>         10   (1.4%)          10   (1.4%)     Bushido::Runner#before_soldier
# >>         10   (1.4%)          10   (1.4%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         33   (4.5%)          10   (1.4%)     Bushido::Point#eql?
# >>         19   (2.6%)           9   (1.2%)     Bushido::Movabler#piece_store
# >>         12   (1.6%)           8   (1.1%)     Bushido::Piece::NameMethods#basic_names
# >>          8   (1.1%)           8   (1.1%)     Bushido::Position::Base.units
# >>          7   (0.9%)           7   (0.9%)     #<Module:0x007ff8f138b7f0>.kconv
# >>         30   (4.1%)           7   (0.9%)     Bushido::Position::Hpos.lookup
# >>          7   (0.9%)           7   (0.9%)     ActiveSupport::Inflector#inflections
# >>         55   (7.4%)           7   (0.9%)     Bushido::Runner#execute
# >>         18   (2.4%)           6   (0.8%)     <top (required)>
# >>          5   (0.7%)           5   (0.7%)     Bushido::Point#initialize
# >>          5   (0.7%)           5   (0.7%)     Bushido::Piece::VectorMethods#select_vectors2
# >>          5   (0.7%)           5   (0.7%)     Hash#slice
# >>         37   (5.0%)           5   (0.7%)     Bushido::Position::Vpos.lookup
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:    67 self (9.1%)  /    484 total (65.5%)
# >>   callers:
# >>      595  (  122.9%)  Bushido::SkillMonitor#execute
# >>      484  (  100.0%)  Bushido::Player#execute
# >>      484  (  100.0%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      289  (   59.7%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      175  (   36.2%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>   callees (417 total):
# >>      595  (  142.7%)  Bushido::SkillMonitor#execute
# >>      484  (  116.1%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      289  (   69.3%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      175  (   42.0%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>       76  (   18.2%)  Bushido::SkillMonitor#cached_soldiers
# >>       54  (   12.9%)  Bushido::AttackInfo#board_parser
# >>       47  (   11.3%)  Bushido::DefenseInfo#board_parser
# >>       41  (    9.8%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>       30  (    7.2%)  Bushido::Point#==
# >>       28  (    6.7%)  Bushido::Board::ReaderMethods#[]
# >>       27  (    6.5%)  Bushido::Point#reverse_if_white
# >>       24  (    5.8%)  block (4 levels) in memory_record
# >>       19  (    4.6%)  Bushido::SkillGroupInfo#model
# >>       12  (    2.9%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>       11  (    2.6%)  Bushido::Runner#current_soldier
# >>       10  (    2.4%)  Bushido::Soldier#reverse
# >>        9  (    2.2%)  Bushido::Runner#before_soldier
# >>        5  (    1.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        4  (    1.0%)  Bushido::BoardParser::FireBoardParser#other_objects
# >>        2  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        2  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        2  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        2  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        2  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        2  (    0.5%)  Bushido::ApplicationMemoryRecord#<=>
# >>        1  (    0.2%)  Object#presence
# >>        1  (    0.2%)  Bushido::BoardParser::Base#soldiers
# >>        1  (    0.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#gentei_match_any
# >>        1  (    0.2%)  Bushido::BoardParser::FireBoardParser#trigger_soldiers
# >>        1  (    0.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        1  (    0.2%)  Bushido::Player#board
# >>        1  (    0.2%)  Bushido::Piece.fetch
# >>        1  (    0.2%)  Bushido::SkillSet#defense_infos
# >>   code:
# >>                                   |    11  |     def execute
# >>                                   |    12  |       skip = Object.new
# >>   484   (65.5%)                   |    13  |       SkillGroupInfo.each do |group|
# >>     1    (0.1%)                   |    14  |         list = player.skill_set.public_send(group.var_key)
# >>   483   (65.4%)                   |    15  |         group.model.each do |e|
# >>                                   |    16  |           hit_flag = nil
# >>   464   (62.8%) /    10   (1.4%)  |    17  |           catch skip do
# >>                                   |    18  |             # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     9    (1.2%) /     9   (1.2%)  |    19  |             if list.include?(e)
# >>                                   |    20  |               throw skip
# >>                                   |    21  |             end
# >>                                   |    22  | 
# >>                                   |    23  |             # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>     4    (0.5%)                   |    24  |             if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    25  |               throw skip
# >>                                   |    26  |             end
# >>                                   |    27  | 
# >>     5    (0.7%) /     1   (0.1%)  |    28  |             if e.turn_limit
# >>                                   |    29  |               if e.turn_limit < player.mediator.turn_info.counter.next
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
# >>     3    (0.4%)                   |    40  |             if e.teban_eq
# >>                                   |    41  |               if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
# >>                                   |    42  |                 throw skip
# >>                                   |    43  |               end
# >>                                   |    44  |             end
# >>                                   |    45  | 
# >>     4    (0.5%)                   |    46  |             if e.kaisenmae
# >>                                   |    47  |               if player.mediator.kill_counter.positive?
# >>                                   |    48  |                 throw skip
# >>                                   |    49  |               end
# >>                                   |    50  |             end
# >>                                   |    51  | 
# >>     2    (0.3%)                   |    52  |             if e.stroke_only
# >>                                   |    53  |               if player.runner.before_soldier
# >>                                   |    54  |                 throw skip
# >>                                   |    55  |               end
# >>                                   |    56  |             end
# >>                                   |    57  | 
# >>     2    (0.3%)                   |    58  |             if e.kill_only
# >>                                   |    59  |               unless player.runner.tottakoma
# >>                                   |    60  |                 throw skip
# >>                                   |    61  |               end
# >>                                   |    62  |             end
# >>                                   |    63  | 
# >>     4    (0.5%)                   |    64  |             if v = e.hold_piece_count_eq
# >>                                   |    65  |               if player.pieces.size != v
# >>                                   |    66  |                 throw skip
# >>                                   |    67  |               end
# >>                                   |    68  |             end
# >>                                   |    69  | 
# >>   126   (17.1%)                   |    70  |             e.board_parser.other_objects.each do |obj|
# >>                                   |    71  |               # 何もない
# >>                                   |    72  |               if obj[:something] == "○"
# >>    20    (2.7%)                   |    73  |                 pt = obj[:point].reverse_if_white(player.location)
# >>    27    (3.7%)                   |    74  |                 if player.board[pt]
# >>                                   |    75  |                   throw skip
# >>                                   |    76  |                 end
# >>                                   |    77  |               end
# >>                                   |    78  | 
# >>                                   |    79  |               # 何かある
# >>     1    (0.1%) /     1   (0.1%)  |    80  |               if obj[:something] == "●"
# >>     1    (0.1%)                   |    81  |                 pt = obj[:point].reverse_if_white(player.location)
# >>     2    (0.3%)                   |    82  |                 if !player.board[pt]
# >>                                   |    83  |                   throw skip
# >>                                   |    84  |                 end
# >>                                   |    85  |               end
# >>                                   |    86  | 
# >>                                   |    87  |               # 移動元ではない
# >>     1    (0.1%) /     1   (0.1%)  |    88  |               if obj[:something] == "☆"
# >>                                   |    89  |                 pt = obj[:point].reverse_if_white(player.location)
# >>     1    (0.1%)                   |    90  |                 before_soldier = player.runner.before_soldier
# >>                                   |    91  |                 if before_soldier && pt == before_soldier.point
# >>                                   |    92  |                   throw skip
# >>                                   |    93  |                 end
# >>                                   |    94  |               end
# >>                                   |    95  |             end
# >>                                   |    96  | 
# >>                                   |    97  |             # 移動元(any条件)
# >>    11    (1.5%) /     1   (0.1%)  |    98  |             if v = e.board_parser.other_objects.find_all { |e| e[:something] == "★" }.presence
# >>    15    (2.0%)                   |    99  |               if v.any? {|e|
# >>     6    (0.8%)                   |   100  |                   pt = e[:point].reverse_if_white(player.location)
# >>     8    (1.1%)                   |   101  |                   if before_soldier = player.runner.before_soldier
# >>     1    (0.1%)                   |   102  |                     pt == before_soldier.point
# >>                                   |   103  |                   end
# >>                                   |   104  |                 }
# >>                                   |   105  |               else
# >>                                   |   106  |                 throw skip
# >>                                   |   107  |               end
# >>                                   |   108  |             end
# >>                                   |   109  | 
# >>                                   |   110  |             if e.fuganai
# >>     1    (0.1%)                   |   111  |               if player.pieces.include?(Piece.fetch(:pawn))
# >>                                   |   112  |                 throw skip
# >>                                   |   113  |               end
# >>                                   |   114  |             end
# >>                                   |   115  | 
# >>     1    (0.1%)                   |   116  |             if e.fu_igai_mottetara_dame
# >>                                   |   117  |               unless (player.pieces - [Piece.fetch(:pawn)]).empty?
# >>                                   |   118  |                 throw skip
# >>                                   |   119  |               end
# >>                                   |   120  |             end
# >>                                   |   121  | 
# >>    43    (5.8%)                   |   122  |             if v = e.hold_piece_eq
# >>     2    (0.3%)                   |   123  |               if player.pieces.sort != v.sort
# >>                                   |   124  |                 throw skip
# >>                                   |   125  |               end
# >>                                   |   126  |             end
# >>                                   |   127  | 
# >>    17    (2.3%)                   |   128  |             if v = e.hold_piece_in
# >>                                   |   129  |               unless v.all? {|x| player.pieces.include?(x) }
# >>                                   |   130  |                 throw skip
# >>                                   |   131  |               end
# >>                                   |   132  |             end
# >>                                   |   133  | 
# >>     3    (0.4%)                   |   134  |             if v = e.hold_piece_not_in
# >>                                   |   135  |               if v.any? {|x| player.pieces.include?(x) }
# >>                                   |   136  |                 throw skip
# >>                                   |   137  |               end
# >>                                   |   138  |             end
# >>                                   |   139  | 
# >>     2    (0.3%)                   |   140  |             if v = e.triggers
# >>                                   |   141  |               current_soldier = player.runner.current_soldier
# >>                                   |   142  |               if player.location.key == :white
# >>                                   |   143  |                 current_soldier = current_soldier.reverse
# >>                                   |   144  |               end
# >>                                   |   145  |               v.each do |soldier|
# >>                                   |   146  |                 if current_soldier != soldier
# >>                                   |   147  |                   throw skip
# >>                                   |   148  |                 end
# >>                                   |   149  |               end
# >>                                   |   150  |             end
# >>                                   |   151  | 
# >>                                   |   152  |             # ここは位置のハッシュを作っておくのがいいかもしれん
# >>    14    (1.9%)                   |   153  |             if v = e.board_parser.trigger_soldiers.presence
# >>    11    (1.5%)                   |   154  |               current_soldier = player.runner.current_soldier
# >>                                   |   155  |               if player.location.key == :white
# >>    10    (1.4%)                   |   156  |                 current_soldier = current_soldier.reverse
# >>                                   |   157  |               end
# >>     3    (0.4%)                   |   158  |               v.each do |soldier|
# >>     3    (0.4%) /     2   (0.3%)  |   159  |                 if current_soldier != soldier
# >>                                   |   160  |                   throw skip
# >>                                   |   161  |                 end
# >>                                   |   162  |               end
# >>                                   |   163  |             end
# >>                                   |   164  | 
# >>    76   (10.3%)                   |   165  |             soldiers = cached_soldiers(e)
# >>                                   |   166  | 
# >>                                   |   167  |             # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
# >>     1    (0.1%)                   |   168  |             if v = e.gentei_match_any
# >>                                   |   169  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   170  |               else
# >>                                   |   171  |                 throw skip
# >>                                   |   172  |               end
# >>                                   |   173  |             end
# >>                                   |   174  | 
# >>                                   |   175  |             # どれかが盤上に含まれる
# >>     5    (0.7%)                   |   176  |             if v = e.board_parser.any_exist_soldiers.presence
# >>                                   |   177  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   178  |               else
# >>                                   |   179  |                 throw skip
# >>                                   |   180  |               end
# >>                                   |   181  |             end
# >>                                   |   182  | 
# >>                                   |   183  |             if e.compare_condition == :equal
# >>                                   |   184  |               hit_flag = (soldiers.sort == e.sorted_soldiers)
# >>     3    (0.4%) /     1   (0.1%)  |   185  |             elsif e.compare_condition == :include
# >>   145   (19.6%) /    41   (5.5%)  |   186  |               hit_flag = e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
# >>                                   |   187  |             else
