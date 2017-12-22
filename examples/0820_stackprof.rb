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

# >> 7610.6 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 1639 (0.00% miss rate)
# >>   GC: 275 (16.78%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        771  (47.0%)         561  (34.2%)     Bushido::SkillMonitor#on_board_soldiers2
# >>        275  (16.8%)         275  (16.8%)     (garbage collection)
# >>        126   (7.7%)         126   (7.7%)     Bushido::Point#to_xy
# >>        219  (13.4%)         113   (6.9%)     Bushido::Point#hash
# >>         82   (5.0%)          81   (4.9%)     Bushido::Position::Base.lookup
# >>        130   (7.9%)          34   (2.1%)     Bushido::Point.lookup
# >>         35   (2.1%)          30   (1.8%)     Bushido::Parser#file_parse
# >>         29   (1.8%)          29   (1.8%)     block (4 levels) in memory_record
# >>         62   (3.8%)          22   (1.3%)     Bushido::Movabler#piece_store
# >>         23   (1.4%)          22   (1.3%)     Bushido::Piece::VectorMethods#select_vectors2
# >>        215  (13.1%)          18   (1.1%)     Bushido::Runner#execute
# >>         15   (0.9%)          15   (0.9%)     Bushido::Battler#to_soldier
# >>         13   (0.8%)          13   (0.8%)     ActiveSupport::Duration#initialize
# >>         12   (0.7%)          12   (0.7%)     Bushido::Position::Base.units
# >>         11   (0.7%)          11   (0.7%)     Bushido::HandLog#initialize
# >>         10   (0.6%)          10   (0.6%)     Hash#slice
# >>          8   (0.5%)           8   (0.5%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>          8   (0.5%)           8   (0.5%)     Bushido::HandLog::OfficialFormatter#initialize
# >>         12   (0.7%)           8   (0.5%)     Bushido::Piece::NameMethods#basic_names
# >>          7   (0.4%)           7   (0.4%)     Bushido::Parser::Base::ConverterMethods#mb_ljust
# >>        115   (7.0%)           6   (0.4%)     Bushido::Movabler#movable_infos
# >>         47   (2.9%)           6   (0.4%)     Bushido::Position::Vpos.lookup
# >>          8   (0.5%)           6   (0.4%)     Bushido::Parser::Base::ConverterMethods#clock_exist?
# >>          7   (0.4%)           6   (0.4%)     Bushido::Position::Hpos#number_format
# >>         12   (0.7%)           6   (0.4%)     Bushido::BoardParser::KifBoardParser#soldiers_create
# >>          7   (0.4%)           6   (0.4%)     <top (required)>
# >>         46   (2.8%)           5   (0.3%)     Bushido::Position::Hpos.lookup
# >>        807  (49.2%)           5   (0.3%)     Bushido::SkillMonitor#execute_one
# >>         14   (0.9%)           5   (0.3%)     Bushido::Soldier#reverse
# >>         19   (1.2%)           5   (0.3%)     <top (required)>
# >> Bushido::SkillMonitor#execute_one (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:16)
# >>   samples:     5 self (0.3%)  /    807 total (49.2%)
# >>   callers:
# >>     1585  (  196.4%)  Bushido::SkillMonitor#execute_one
# >>      807  (  100.0%)  Bushido::SkillMonitor#execute
# >>   callees (802 total):
# >>     1585  (  197.6%)  Bushido::SkillMonitor#execute_one
# >>      771  (   96.1%)  Bushido::SkillMonitor#on_board_soldiers2
# >>        4  (    0.5%)  Bushido::Point#hash
# >>        3  (    0.4%)  Bushido::BoardParser::FireBoardParser#other_objects_hash2
# >>        3  (    0.4%)  Bushido::AttackInfo#board_parser
# >>        3  (    0.4%)  Bushido::BoardParser::Base::SomeAccessors#soldiers_hash2
# >>        2  (    0.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        2  (    0.2%)  block (4 levels) in memory_record
# >>        2  (    0.2%)  Bushido::Point#eql?
# >>        2  (    0.2%)  Bushido::SkillSet#attack_infos
# >>        2  (    0.2%)  Bushido::DefenseInfo#board_parser
# >>        2  (    0.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        1  (    0.1%)  Object#presence
# >>        1  (    0.1%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        1  (    0.1%)  Bushido::Player::SkillMonitorMethods#skill_set
# >>        1  (    0.1%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        1  (    0.1%)  Bushido::SkillSet#defense_infos
# >>        1  (    0.1%)  Bushido::TacticInfo#var_key
# >>   code:
# >>                                   |    16  |     def execute_one(e)
# >>   807   (49.2%) /     1   (0.1%)  |    17  |       catch :skip do
# >>                                   |    18  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     8    (0.5%)                   |    19  |         list = player.skill_set.public_send(e.tactic_info.var_key)
# >>                                   |    20  |         if list.include?(e)
# >>                                   |    21  |           throw :skip
# >>                                   |    22  |         end
# >>                                   |    23  | 
# >>                                   |    24  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>                                   |    25  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    26  |           throw :skip
# >>                                   |    27  |         end
# >>                                   |    28  | 
# >>                                   |    29  |         if e.turn_limit
# >>                                   |    30  |           if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    31  |             throw :skip
# >>                                   |    32  |           end
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>                                   |    35  |         if e.turn_eq
# >>                                   |    36  |           if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    37  |             throw :skip
# >>                                   |    38  |           end
# >>                                   |    39  |         end
# >>                                   |    40  | 
# >>                                   |    41  |         if e.order_key
# >>                                   |    42  |           if e.order_key != player.mediator.turn_info.order_key
# >>                                   |    43  |             throw :skip
# >>                                   |    44  |           end
# >>                                   |    45  |         end
# >>                                   |    46  | 
# >>                                   |    47  |         if e.cold_war
# >>                                   |    48  |           if player.mediator.kill_counter.positive?
# >>                                   |    49  |             throw :skip
# >>                                   |    50  |           end
# >>                                   |    51  |         end
# >>                                   |    52  | 
# >>                                   |    53  |         if e.stroke_only
# >>                                   |    54  |           if before_soldier
# >>                                   |    55  |             throw :skip
# >>                                   |    56  |           end
# >>                                   |    57  |         end
# >>                                   |    58  | 
# >>     1    (0.1%)                   |    59  |         if e.kill_only
# >>                                   |    60  |           unless player.runner.killed_piece
# >>                                   |    61  |             throw :skip
# >>                                   |    62  |           end
# >>                                   |    63  |         end
# >>                                   |    64  | 
# >>     1    (0.1%)                   |    65  |         if v = e.hold_piece_count_eq
# >>                                   |    66  |           if player.pieces.size != v
# >>                                   |    67  |             throw :skip
# >>                                   |    68  |           end
# >>                                   |    69  |         end
# >>                                   |    70  | 
# >>                                   |    71  |         if true
# >>                                   |    72  |           # 何もない
# >>     7    (0.4%) /     1   (0.1%)  |    73  |           if ary = e.board_parser.other_objects_hash2[player.location.key]["○"]
# >>     2    (0.1%)                   |    74  |             ary.each do |v|
# >>     2    (0.1%)                   |    75  |               if player.board.surface[v]
# >>                                   |    76  |                 throw :skip
# >>                                   |    77  |               end
# >>                                   |    78  |             end
# >>                                   |    79  |           end
# >>                                   |    80  |           # 何かある
# >>     1    (0.1%)                   |    81  |           if ary = e.board_parser.other_objects_hash2[player.location.key]["●"]
# >>                                   |    82  |             ary.each do |e|
# >>                                   |    83  |               if !player.board.surface[e[:point]]
# >>                                   |    84  |                 throw :skip
# >>                                   |    85  |               end
# >>                                   |    86  |             end
# >>                                   |    87  |           end
# >>                                   |    88  | 
# >>                                   |    89  |           # 移動元ではない
# >>                                   |    90  |           if ary = e.board_parser.other_objects_hash2[player.location.key]["☆"]
# >>                                   |    91  |             # 移動元についての指定があるのに移動元がない場合はそもそも状況が異なるのでskip
# >>                                   |    92  |             unless before_soldier
# >>                                   |    93  |               throw :skip
# >>                                   |    94  |             end
# >>                                   |    95  |             ary.each do |e|
# >>                                   |    96  |               if e[:point] == before_soldier.point
# >>                                   |    97  |                 throw :skip
# >>                                   |    98  |               end
# >>                                   |    99  |             end
# >>                                   |   100  |           end
# >>                                   |   101  | 
# >>                                   |   102  |           # 移動元(any条件)
# >>     1    (0.1%) /     1   (0.1%)  |   103  |           if points_hash = e.board_parser.other_objects_hash3[player.location.key]["★"]
# >>                                   |   104  |             # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   105  |             unless before_soldier
# >>                                   |   106  |               throw :skip
# >>                                   |   107  |             end
# >>                                   |   108  |             if points_hash[before_soldier.point]
# >>                                   |   109  |               # 移動元があったのでOK
# >>                                   |   110  |             else
# >>                                   |   111  |               throw :skip
# >>                                   |   112  |             end
# >>                                   |   113  |           end
# >>                                   |   114  |         else
# >>                                   |   115  |           # 何もない
# >>                                   |   116  |           if ary = e.board_parser.other_objects_hash_ary["○"]
# >>                                   |   117  |             ary.each do |obj|
# >>                                   |   118  |               pt = obj[:point].reverse_if_white(player.location)
# >>                                   |   119  |               if player.board[pt]
# >>                                   |   120  |                 throw :skip
# >>                                   |   121  |               end
# >>                                   |   122  |             end
# >>                                   |   123  |           end
# >>                                   |   124  | 
# >>                                   |   125  |           # 何かある
# >>                                   |   126  |           if ary = e.board_parser.other_objects_hash_ary["●"]
# >>                                   |   127  |             ary.each do |obj|
# >>                                   |   128  |               pt = obj[:point].reverse_if_white(player.location)
# >>                                   |   129  |               if !player.board[pt]
# >>                                   |   130  |                 throw :skip
# >>                                   |   131  |               end
# >>                                   |   132  |             end
# >>                                   |   133  |           end
# >>                                   |   134  | 
# >>                                   |   135  |           # 移動元ではない
# >>                                   |   136  |           if ary = e.board_parser.other_objects_hash_ary["☆"]
# >>                                   |   137  |             ary.each do |obj|
# >>                                   |   138  |               pt = obj[:point].reverse_if_white(player.location)
# >>                                   |   139  |               before_soldier = player.runner.before_soldier
# >>                                   |   140  |               if before_soldier && pt == before_soldier.point
# >>                                   |   141  |                 throw :skip
# >>                                   |   142  |               end
# >>                                   |   143  |             end
# >>                                   |   144  |           end
# >>                                   |   145  | 
# >>                                   |   146  |           # 移動元(any条件)
# >>                                   |   147  |           ary = e.board_parser.other_objects_hash_ary["★"]
# >>                                   |   148  |           if ary.present?
# >>                                   |   149  |             before_soldier = player.runner.before_soldier
# >>                                   |   150  |             if !before_soldier
# >>                                   |   151  |               # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   152  |               throw :skip
# >>                                   |   153  |             end
# >>                                   |   154  |             if ary.any? { |e|
# >>                                   |   155  |                 pt = e[:point].reverse_if_white(player.location)
# >>                                   |   156  |                 pt == before_soldier.point
# >>                                   |   157  |               }
# >>                                   |   158  |             else
# >>                                   |   159  |               throw :skip
# >>                                   |   160  |             end
# >>                                   |   161  |           end
# >>                                   |   162  | 
# >>                                   |   163  |         end
# >>                                   |   164  | 
# >>                                   |   165  |         if e.not_have_pawn
# >>                                   |   166  |           if player_pieces_sort_hash.has_key?(Piece.fetch(:pawn))
# >>                                   |   167  |             throw :skip
# >>                                   |   168  |           end
# >>                                   |   169  |         end
# >>                                   |   170  | 
# >>                                   |   171  |         if e.not_have_anything_except_pawn
# >>                                   |   172  |           unless (player_pieces_sort - [Piece.fetch(:pawn)]).empty?
# >>                                   |   173  |             throw :skip
# >>                                   |   174  |           end
# >>                                   |   175  |         end
# >>                                   |   176  | 
# >>     1    (0.1%)                   |   177  |         if v = e.hold_piece_eq
# >>                                   |   178  |           if player_pieces_sort != v
# >>                                   |   179  |             throw :skip
# >>                                   |   180  |           end
# >>                                   |   181  |         end
# >>                                   |   182  | 
# >>                                   |   183  |         # 指定の駒をすべて持っているならOK
# >>     2    (0.1%)                   |   184  |         if v = e.hold_piece_in
# >>                                   |   185  |           if v.all? {|x| player_pieces_sort_hash.has_key?(x) }
# >>                                   |   186  |           else
# >>                                   |   187  |             throw :skip
# >>                                   |   188  |           end
# >>                                   |   189  |         end
# >>                                   |   190  | 
# >>                                   |   191  |         # 指定の駒をどれか持っていたらskip
# >>                                   |   192  |         if v = e.hold_piece_not_in
# >>                                   |   193  |           if v.any? {|x| player_pieces_sort_hash.has_key?(x) }
# >>                                   |   194  |             throw :skip
# >>                                   |   195  |           end
# >>                                   |   196  |         end
# >>                                   |   197  | 
# >>                                   |   198  |         if true
# >>                                   |   199  |           # どれかが盤上に含まれる(駒の一致も確認)
# >>     2    (0.1%)                   |   200  |           if ary = e.board_parser.other_objects_hash4[player.location.key].presence
# >>                                   |   201  |             if ary.any? { |e| on_board_soldiers2.include?(e) }
# >>                                   |   202  |             else
# >>                                   |   203  |               throw :skip
# >>                                   |   204  |             end
# >>                                   |   205  |           end
# >>                                   |   206  | 
# >>                                   |   207  |         else
# >>                                   |   208  |           # どれかが盤上に含まれる
# >>                                   |   209  |           soldiers = on_board_soldiers(e)
# >>                                   |   210  |           if v = e.board_parser.any_exist_soldiers.presence
# >>                                   |   211  |             if v.any? {|o| soldiers.include?(o) } # FIXME: hashにする
# >>                                   |   212  |             else
# >>                                   |   213  |               throw :skip
# >>                                   |   214  |             end
# >>                                   |   215  |           end
# >>                                   |   216  |         end
# >>                                   |   217  | 
# >>                                   |   218  |         if true
# >>     3    (0.2%)                   |   219  |           ary = e.board_parser.soldiers_hash2[player.location.key]
# >>  1554   (94.8%) /     2   (0.1%)  |   220  |           if ary.all? { |e| on_board_soldiers2.include?(e) }
# >>                                   |   221  |           else
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:     4 self (0.2%)  /    881 total (53.8%)
# >>   callers:
# >>      881  (  100.0%)  Bushido::Player#execute
# >>      807  (   91.6%)  Bushido::SkillMonitor#execute
# >>   callees (877 total):
# >>      807  (   92.0%)  Bushido::SkillMonitor#execute_one
# >>      807  (   92.0%)  Bushido::SkillMonitor#execute
# >>       64  (    7.3%)  Bushido::TacticInfo.soldier_hash_table
# >>        4  (    0.5%)  Bushido::SkillMonitor#current_soldier
# >>        2  (    0.2%)  Bushido::Point#hash
# >>   code:
# >>                                   |    11  |     def execute
# >>    74    (4.5%) /     4   (0.2%)  |    12  |       elements = TacticInfo.soldier_hash_table[current_soldier] || []
# >>  1614   (98.5%)                   |    13  |       elements.each { |e| execute_one(e) }
# >>                                   |    14  |     end
# >> Bushido::Position::Base.lookup (/Users/ikeda/src/bushido/lib/bushido/position.rb:73)
# >>   samples:    81 self (4.9%)  /     82 total (5.0%)
# >>   callers:
# >>       41  (   50.0%)  Bushido::Position::Hpos.lookup
# >>       41  (   50.0%)  Bushido::Position::Vpos.lookup
# >>   callees (1 total):
# >>        1  (  100.0%)  Bushido::Position::Base.units_set
# >>   code:
# >>                                   |    73  |         def lookup(value)
# >>    64    (3.9%) /    64   (3.9%)  |    74  |           if value.kind_of?(Base)
# >>     3    (0.2%) /     3   (0.2%)  |    75  |             return value
# >>                                   |    76  |           end
# >>     2    (0.1%) /     2   (0.1%)  |    77  |           if value.kind_of?(String)
# >>     1    (0.1%)                   |    78  |             value = units_set[value]
# >>                                   |    79  |           end
# >>     1    (0.1%) /     1   (0.1%)  |    80  |           if value
# >>     7    (0.4%) /     7   (0.4%)  |    81  |             @instance ||= {}
# >>     4    (0.2%) /     4   (0.2%)  |    82  |             @instance[value] ||= new(value).freeze
# >>                                   |    83  |           end
