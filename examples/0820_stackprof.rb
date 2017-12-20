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

# >> 3802.6 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 742 (0.00% miss rate)
# >>   GC: 98 (13.21%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>         98  (13.2%)          98  (13.2%)     (garbage collection)
# >>        445  (60.0%)          88  (11.9%)     Bushido::SkillMonitor#execute
# >>         75  (10.1%)          75  (10.1%)     Bushido::Position::Base.lookup
# >>         67   (9.0%)          67   (9.0%)     block (4 levels) in memory_record
# >>         42   (5.7%)          42   (5.7%)     Bushido::Point#to_xy
# >>         41   (5.5%)          22   (3.0%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>        110  (14.8%)          22   (3.0%)     Bushido::Point.lookup
# >>         19   (2.6%)          19   (2.6%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         53   (7.1%)          15   (2.0%)     Bushido::Point#eql?
# >>         24   (3.2%)          13   (1.8%)     Bushido::Soldier#reverse
# >>         28   (3.8%)          12   (1.6%)     Bushido::Movabler#piece_store
# >>         35   (4.7%)          11   (1.5%)     Bushido::Board::ReaderMethods#lookup
# >>          9   (1.2%)           9   (1.2%)     Bushido::Piece::VectorMethods#select_vectors2
# >>          9   (1.2%)           8   (1.1%)     ActiveSupport::Inflector#apply_inflections
# >>         11   (1.5%)           8   (1.1%)     Object#present?
# >>         45   (6.1%)           8   (1.1%)     Bushido::Position::Hpos.lookup
# >>          8   (1.1%)           8   (1.1%)     Bushido::Position::Base.units
# >>         14   (1.9%)           8   (1.1%)     Bushido::Parser#file_parse
# >>         94  (12.7%)           8   (1.1%)     Bushido::ShapeInfo#board_parser
# >>          7   (0.9%)           7   (0.9%)     Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>          7   (0.9%)           7   (0.9%)     Bushido::Battler#to_soldier
# >>          8   (1.1%)           7   (0.9%)     ActiveSupport::Inflector#camelize
# >>          7   (0.9%)           7   (0.9%)     Bushido::Point#initialize
# >>          7   (0.9%)           6   (0.8%)     <top (required)>
# >>         18   (2.4%)           5   (0.7%)     <top (required)>
# >>          5   (0.7%)           5   (0.7%)     Bushido::Parser::Base::ConverterMethods#mb_ljust
# >>         12   (1.6%)           5   (0.7%)     Bushido::BoardParser::KifBoardParser#soldiers_create
# >>          8   (1.1%)           5   (0.7%)     Bushido::Soldier.new_with_promoted
# >>         86  (11.6%)           5   (0.7%)     Bushido::BoardParser::KifBoardParser#cell_walker
# >>          5   (0.7%)           5   (0.7%)     Hash#slice
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:    88 self (11.9%)  /    445 total (60.0%)
# >>   callers:
# >>      584  (  131.2%)  Bushido::SkillMonitor#execute
# >>      445  (  100.0%)  Bushido::Player#execute
# >>      445  (  100.0%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      223  (   50.1%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      201  (   45.2%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>   callees (357 total):
# >>      584  (  163.6%)  Bushido::SkillMonitor#execute
# >>      445  (  124.6%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      223  (   62.5%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      201  (   56.3%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>       86  (   24.1%)  Bushido::AttackInfo#board_parser
# >>       57  (   16.0%)  Bushido::DefenseInfo#board_parser
# >>       47  (   13.2%)  Bushido::Point#==
# >>       27  (    7.6%)  block (4 levels) in memory_record
# >>       23  (    6.4%)  Bushido::SkillMonitor#cached_board_soldiers
# >>       22  (    6.2%)  Bushido::Point#reverse_if_white
# >>       20  (    5.6%)  Bushido::SkillGroupInfo#model
# >>       18  (    5.0%)  Bushido::Board::ReaderMethods#[]
# >>       10  (    2.8%)  Bushido::Soldier#reverse
# >>        7  (    2.0%)  Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>        6  (    1.7%)  Object#presence
# >>        5  (    1.4%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        5  (    1.4%)  Object#present?
# >>        4  (    1.1%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        3  (    0.8%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        3  (    0.8%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        2  (    0.6%)  Bushido::BoardParser::Base#soldiers
# >>        2  (    0.6%)  Bushido::TurnInfo#senteban_or_goteban
# >>        1  (    0.3%)  Bushido::BoardParser::FireBoardParser#any_exist_soldiers
# >>        1  (    0.3%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        1  (    0.3%)  Bushido::SkillSet#attack_infos
# >>        1  (    0.3%)  Bushido::Runner#before_soldier
# >>        1  (    0.3%)  Bushido::Player#board
# >>        1  (    0.3%)  Bushido::DefenseInfo::AttackInfoSharedMethods#gentei_match_any
# >>        1  (    0.3%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        1  (    0.3%)  Bushido::BoardParser::FireBoardParser#trigger_soldiers
# >>        1  (    0.3%)  Bushido::ApplicationMemoryRecord#<=>
# >>        1  (    0.3%)  Bushido::Runner#current_soldier
# >>   code:
# >>                                   |    11  |     def execute
# >>                                   |    12  |       skip = Object.new
# >>   445   (60.0%)                   |    13  |       SkillGroupInfo.each do |group|
# >>     1    (0.1%)                   |    14  |         list = player.skill_set.public_send(group.var_key)
# >>   444   (59.8%)                   |    15  |         group.model.each do |e|
# >>                                   |    16  |           hit_flag = nil
# >>   424   (57.1%) /     3   (0.4%)  |    17  |           catch skip do
# >>                                   |    18  |             # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     5    (0.7%) /     5   (0.7%)  |    19  |             if list.include?(e)
# >>                                   |    20  |               throw skip
# >>                                   |    21  |             end
# >>                                   |    22  | 
# >>                                   |    23  |             # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>                                   |    24  |             if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    25  |               throw skip
# >>                                   |    26  |             end
# >>                                   |    27  | 
# >>     3    (0.4%)                   |    28  |             if e.turn_limit
# >>                                   |    29  |               if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    30  |                 throw skip
# >>                                   |    31  |               end
# >>                                   |    32  |             end
# >>                                   |    33  | 
# >>     6    (0.8%)                   |    34  |             if e.turn_eq
# >>                                   |    35  |               if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    36  |                 throw skip
# >>                                   |    37  |               end
# >>                                   |    38  |             end
# >>                                   |    39  | 
# >>     1    (0.1%)                   |    40  |             if e.teban_eq
# >>     2    (0.3%)                   |    41  |               if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
# >>                                   |    42  |                 throw skip
# >>                                   |    43  |               end
# >>                                   |    44  |             end
# >>                                   |    45  | 
# >>     2    (0.3%) /     1   (0.1%)  |    46  |             if e.kaisenmae
# >>     1    (0.1%) /     1   (0.1%)  |    47  |               if player.mediator.kill_counter.positive?
# >>                                   |    48  |                 throw skip
# >>                                   |    49  |               end
# >>                                   |    50  |             end
# >>                                   |    51  | 
# >>     5    (0.7%)                   |    52  |             if e.stroke_only
# >>                                   |    53  |               if player.runner.before_soldier
# >>                                   |    54  |                 throw skip
# >>                                   |    55  |               end
# >>                                   |    56  |             end
# >>                                   |    57  | 
# >>     3    (0.4%)                   |    58  |             if e.kill_only
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
# >>    97   (13.1%) /     1   (0.1%)  |    71  |             if ary = e.board_parser.other_objects_hash_ary["○"]
# >>    37    (5.0%)                   |    72  |               ary.each do |obj|
# >>    18    (2.4%)                   |    73  |                 pt = obj[:point].reverse_if_white(player.location)
# >>    19    (2.6%)                   |    74  |                 if player.board[pt]
# >>                                   |    75  |                   throw skip
# >>                                   |    76  |                 end
# >>                                   |    77  |               end
# >>                                   |    78  |             end
# >>                                   |    79  | 
# >>                                   |    80  |             # 何かある
# >>    10    (1.3%)                   |    81  |             if ary = e.board_parser.other_objects_hash_ary["●"]
# >>                                   |    82  |               ary.each do |obj|
# >>                                   |    83  |                 pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    84  |                 if !player.board[pt]
# >>                                   |    85  |                   throw skip
# >>                                   |    86  |                 end
# >>                                   |    87  |               end
# >>                                   |    88  |             end
# >>                                   |    89  | 
# >>                                   |    90  |             # 移動元ではない
# >>     9    (1.2%)                   |    91  |             if ary = e.board_parser.other_objects_hash_ary["☆"]
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
# >>    11    (1.5%)                   |   102  |             ary = e.board_parser.other_objects_hash_ary["★"]
# >>     5    (0.7%)                   |   103  |             if ary.present?
# >>     1    (0.1%)                   |   104  |               before_soldier = player.runner.before_soldier
# >>                                   |   105  |               if !before_soldier
# >>                                   |   106  |                 # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   107  |                 throw skip
# >>                                   |   108  |               end
# >>     4    (0.5%)                   |   109  |               if ary.any? { |e|
# >>     4    (0.5%)                   |   110  |                   pt = e[:point].reverse_if_white(player.location)
# >>                                   |   111  |                   pt == before_soldier.point
# >>                                   |   112  |                 }
# >>                                   |   113  |               else
# >>                                   |   114  |                 throw skip
# >>                                   |   115  |               end
# >>                                   |   116  |             end
# >>                                   |   117  | 
# >>     2    (0.3%)                   |   118  |             if e.fuganai
# >>                                   |   119  |               if player.pieces.include?(Piece.fetch(:pawn))
# >>                                   |   120  |                 throw skip
# >>                                   |   121  |               end
# >>                                   |   122  |             end
# >>                                   |   123  | 
# >>     1    (0.1%)                   |   124  |             if e.fu_igai_mottetara_dame
# >>                                   |   125  |               unless (player.pieces - [Piece.fetch(:pawn)]).empty?
# >>                                   |   126  |                 throw skip
# >>                                   |   127  |               end
# >>                                   |   128  |             end
# >>                                   |   129  | 
# >>     3    (0.4%)                   |   130  |             if v = e.hold_piece_eq
# >>     2    (0.3%) /     1   (0.1%)  |   131  |               if player.pieces.sort != v.sort
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
# >>     9    (1.2%)                   |   142  |             if v = e.hold_piece_not_in
# >>                                   |   143  |               if v.any? {|x| player.pieces.include?(x) }
# >>                                   |   144  |                 throw skip
# >>                                   |   145  |               end
# >>                                   |   146  |             end
# >>                                   |   147  | 
# >>     4    (0.5%)                   |   148  |             if v = e.triggers
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
# >>    14    (1.9%)                   |   161  |             if v = e.board_parser.trigger_soldiers.presence
# >>     1    (0.1%)                   |   162  |               current_soldier = player.runner.current_soldier
# >>     2    (0.3%)                   |   163  |               if player.location.key == :white
# >>    10    (1.3%)                   |   164  |                 current_soldier = current_soldier.reverse
# >>                                   |   165  |               end
# >>     7    (0.9%)                   |   166  |               v.each do |soldier|
# >>     7    (0.9%) /     4   (0.5%)  |   167  |                 if current_soldier != soldier
# >>                                   |   168  |                   throw skip
# >>                                   |   169  |                 end
# >>                                   |   170  |               end
# >>                                   |   171  |             end
# >>                                   |   172  | 
# >>    23    (3.1%)                   |   173  |             soldiers = cached_board_soldiers(e)
# >>                                   |   174  | 
# >>                                   |   175  |             # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
# >>     1    (0.1%)                   |   176  |             if v = e.gentei_match_any
# >>                                   |   177  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   178  |               else
# >>                                   |   179  |                 throw skip
# >>                                   |   180  |               end
# >>                                   |   181  |             end
# >>                                   |   182  | 
# >>                                   |   183  |             # どれかが盤上に含まれる
# >>    10    (1.3%)                   |   184  |             if v = e.board_parser.any_exist_soldiers.presence
# >>                                   |   185  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   186  |               else
# >>                                   |   187  |                 throw skip
# >>                                   |   188  |               end
# >>                                   |   189  |             end
# >>                                   |   190  | 
# >>   240   (32.3%) /    71   (9.6%)  |   191  |             if e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
# >>                                   |   192  |               list << e
# >>     1    (0.1%) /     1   (0.1%)  |   193  |               player.runner.skill_set.public_send(group.var_key) << e
# >>                                   |   194  |             end
