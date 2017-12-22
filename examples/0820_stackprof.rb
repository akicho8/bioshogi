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

# >> 3514.6 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 825 (0.00% miss rate)
# >>   GC: 205 (24.85%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        205  (24.8%)         205  (24.8%)     (garbage collection)
# >>         74   (9.0%)          74   (9.0%)     Bushido::Position::Base.lookup
# >>        127  (15.4%)          40   (4.8%)     Bushido::Point.lookup
# >>         38   (4.6%)          28   (3.4%)     Bushido::Parser#file_parse
# >>         28   (3.4%)          28   (3.4%)     block (4 levels) in memory_record
# >>         24   (2.9%)          24   (2.9%)     Bushido::Point#to_xy
# >>         74   (9.0%)          19   (2.3%)     Bushido::SkillMonitor#execute_one
# >>         18   (2.2%)          18   (2.2%)     Bushido::Piece::VectorMethods#select_vectors2
# >>         55   (6.7%)          15   (1.8%)     Bushido::Movabler#piece_store
# >>         38   (4.6%)          14   (1.7%)     Bushido::Soldier#reverse
# >>         48   (5.8%)          13   (1.6%)     Bushido::Position::Hpos.lookup
# >>         13   (1.6%)          13   (1.6%)     Bushido::Battler#to_soldier
# >>         20   (2.4%)          12   (1.5%)     Bushido::Point#hash
# >>        202  (24.5%)          12   (1.5%)     Bushido::Runner#execute
# >>         11   (1.3%)          11   (1.3%)     Bushido::HandLog#initialize
# >>         10   (1.2%)          10   (1.2%)     Bushido::Position::Base.units
# >>         12   (1.5%)          10   (1.2%)     Hash#transform_keys
# >>          9   (1.1%)           9   (1.1%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         50   (6.1%)           7   (0.8%)     Set#each
# >>          7   (0.8%)           7   (0.8%)     ActiveSupport::Duration#initialize
# >>          6   (0.7%)           6   (0.7%)     Hash#slice
# >>          7   (0.8%)           6   (0.7%)     Bushido::Position::Hpos#number_format
# >>          6   (0.7%)           6   (0.7%)     Bushido::Parser::Base::ConverterMethods#mb_ljust
# >>         20   (2.4%)           6   (0.7%)     Bushido::Point#eql?
# >>          8   (1.0%)           6   (0.7%)     Bushido::Position::Vpos#number_format
# >>          7   (0.8%)           6   (0.7%)     Bushido::Piece::NameMethods#basic_names
# >>          6   (0.7%)           6   (0.7%)     Bushido::Position::Base.value_range
# >>          7   (0.8%)           5   (0.6%)     <top (required)>
# >>         19   (2.3%)           5   (0.6%)     <top (required)>
# >>          6   (0.7%)           5   (0.6%)     #<Module:0x007fa990c34ba0>.size_type
# >> Bushido::SkillMonitor#execute_one (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:16)
# >>   samples:    19 self (2.3%)  /     74 total (9.0%)
# >>   callers:
# >>       96  (  129.7%)  Bushido::SkillMonitor#execute_one
# >>       74  (  100.0%)  Bushido::SkillMonitor#execute
# >>   callees (55 total):
# >>       96  (  174.5%)  Bushido::SkillMonitor#execute_one
# >>       30  (   54.5%)  Bushido::SkillMonitor#on_board_soldiers
# >>        5  (    9.1%)  Bushido::DefenseInfo#board_parser
# >>        5  (    9.1%)  block (4 levels) in memory_record
# >>        3  (    5.5%)  Bushido::Point#==
# >>        2  (    3.6%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        2  (    3.6%)  Bushido::AttackInfo#board_parser
# >>        1  (    1.8%)  Bushido::SkillMonitor#before_soldier
# >>        1  (    1.8%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        1  (    1.8%)  Bushido::Player#board
# >>        1  (    1.8%)  Bushido::TacticInfo#var_key
# >>        1  (    1.8%)  Bushido::Point#eql?
# >>        1  (    1.8%)  Bushido::BoardParser::FireBoardParser#other_objects_hash2
# >>        1  (    1.8%)  Bushido::Player::SkillMonitorMethods#skill_set
# >>        1  (    1.8%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>   code:
# >>                                   |    16  |     def execute_one(e)
# >>    74    (9.0%)                   |    17  |       catch :skip do
# >>                                   |    18  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     5    (0.6%)                   |    19  |         list = player.skill_set.public_send(e.tactic_info.var_key)
# >>                                   |    20  |         if list.include?(e)
# >>                                   |    21  |           throw :skip
# >>                                   |    22  |         end
# >>                                   |    23  | 
# >>                                   |    24  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>                                   |    25  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    26  |           throw :skip
# >>                                   |    27  |         end
# >>                                   |    28  | 
# >>     2    (0.2%)                   |    29  |         if e.turn_limit
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
# >>     1    (0.1%)                   |    41  |         if e.order_key
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
# >>     1    (0.1%)                   |    53  |         if e.stroke_only
# >>                                   |    54  |           if before_soldier
# >>                                   |    55  |             throw :skip
# >>                                   |    56  |           end
# >>                                   |    57  |         end
# >>                                   |    58  | 
# >>                                   |    59  |         if e.kill_only
# >>                                   |    60  |           unless player.runner.killed_piece
# >>                                   |    61  |             throw :skip
# >>                                   |    62  |           end
# >>                                   |    63  |         end
# >>                                   |    64  | 
# >>                                   |    65  |         if v = e.hold_piece_count_eq
# >>                                   |    66  |           if player.pieces.size != v
# >>                                   |    67  |             throw :skip
# >>                                   |    68  |           end
# >>                                   |    69  |         end
# >>                                   |    70  | 
# >>                                   |    71  |         if true
# >>                                   |    72  |           # 何もない
# >>     5    (0.6%)                   |    73  |           if ary = e.board_parser.other_objects_hash2[player.location.key]["○"]
# >>     2    (0.2%)                   |    74  |             ary.each do |v|
# >>     2    (0.2%) /     1   (0.1%)  |    75  |               if player.board.surface[v]
# >>                                   |    76  |                 throw :skip
# >>                                   |    77  |               end
# >>                                   |    78  |             end
# >>                                   |    79  |           end
# >>                                   |    80  |           # 何かある
# >>                                   |    81  |           if ary = e.board_parser.other_objects_hash2[player.location.key]["●"]
# >>                                   |    82  |             ary.each do |e|
# >>                                   |    83  |               if !player.board.surface[e[:point]]
# >>                                   |    84  |                 throw :skip
# >>                                   |    85  |               end
# >>                                   |    86  |             end
# >>                                   |    87  |           end
# >>                                   |    88  | 
# >>                                   |    89  |           # 移動元ではない
# >>     2    (0.2%)                   |    90  |           if ary = e.board_parser.other_objects_hash2[player.location.key]["☆"]
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
# >>     1    (0.1%)                   |   103  |           if points_hash = e.board_parser.other_objects_hash3[player.location.key]["★"]
# >>                                   |   104  |             # 移動元がないということは、もう何も該当しないので skip
# >>     1    (0.1%)                   |   105  |             unless before_soldier
# >>                                   |   106  |               throw :skip
# >>                                   |   107  |             end
# >>     1    (0.1%)                   |   108  |             if points_hash[before_soldier.point]
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
# >>     1    (0.1%)                   |   171  |         if e.not_have_anything_except_pawn
# >>                                   |   172  |           unless (player_pieces_sort - [Piece.fetch(:pawn)]).empty?
# >>                                   |   173  |             throw :skip
# >>                                   |   174  |           end
# >>                                   |   175  |         end
# >>                                   |   176  | 
# >>                                   |   177  |         if v = e.hold_piece_eq
# >>                                   |   178  |           if player_pieces_sort != v
# >>                                   |   179  |             throw :skip
# >>                                   |   180  |           end
# >>                                   |   181  |         end
# >>                                   |   182  | 
# >>                                   |   183  |         # 指定の駒をすべて持っているならOK
# >>                                   |   184  |         if v = e.hold_piece_in
# >>                                   |   185  |           if v.all? {|x| player_pieces_sort_hash.has_key?(x) }
# >>                                   |   186  |           else
# >>                                   |   187  |             throw :skip
# >>                                   |   188  |           end
# >>                                   |   189  |         end
# >>                                   |   190  | 
# >>                                   |   191  |         # 指定の駒をどれか持っていたらskip
# >>     1    (0.1%)                   |   192  |         if v = e.hold_piece_not_in
# >>                                   |   193  |           if v.any? {|x| player_pieces_sort_hash.has_key?(x) }
# >>                                   |   194  |             throw :skip
# >>                                   |   195  |           end
# >>                                   |   196  |         end
# >>                                   |   197  | 
# >>                                   |   198  |         if true
# >>                                   |   199  |           # どれかが盤上に含まれる(駒の一致も確認)
# >>     1    (0.1%) /     1   (0.1%)  |   200  |           if v = e.board_parser.other_objects_hash4[player.location]
# >>                                   |   201  |             if v.any? { |e| on_board_soldiers2.include?(e) }
# >>                                   |   202  |             else
# >>                                   |   203  |               throw :skip
# >>                                   |   204  |             end
# >>                                   |   205  |           end
# >>                                   |   206  | 
# >>                                   |   207  |         else
# >>                                   |   208  |           # どれかが盤上に含まれる
# >>                                   |   209  |           if v = e.board_parser.any_exist_soldiers.presence
# >>                                   |   210  |             if v.any? {|o| soldiers.include?(o) } # FIXME: hashにする
# >>                                   |   211  |             else
# >>                                   |   212  |               throw :skip
# >>                                   |   213  |             end
# >>                                   |   214  |           end
# >>                                   |   215  |         end
# >>                                   |   216  | 
# >>    30    (3.6%)                   |   217  |         soldiers = on_board_soldiers(e)
# >>                                   |   218  | 
# >>    40    (4.8%) /    17   (2.1%)  |   219  |         if e.board_parser.soldiers.all? { |e| soldiers.include?(e) } # FIXME: hashにする
# >>                                   |   220  |           list << e
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:     3 self (0.4%)  /    157 total (19.0%)
# >>   callers:
# >>      157  (  100.0%)  Bushido::Player#execute
# >>       74  (   47.1%)  Bushido::SkillMonitor#execute
# >>   callees (154 total):
# >>       74  (   48.1%)  Bushido::SkillMonitor#execute_one
# >>       74  (   48.1%)  Bushido::SkillMonitor#execute
# >>       67  (   43.5%)  Bushido::TacticInfo.soldier_hash_table
# >>       12  (    7.8%)  Bushido::SkillMonitor#current_soldier
# >>        1  (    0.6%)  Bushido::Point#hash
# >>   code:
# >>                                   |    11  |     def execute
# >>    83   (10.1%) /     3   (0.4%)  |    12  |       elements = TacticInfo.soldier_hash_table[current_soldier] || []
# >>   148   (17.9%)                   |    13  |       elements.each { |e| execute_one(e) }
# >>                                   |    14  |     end
# >> Bushido::Position::Base.lookup (/Users/ikeda/src/bushido/lib/bushido/position.rb:73)
# >>   samples:    74 self (9.0%)  /     74 total (9.0%)
# >>   callers:
# >>       39  (   52.7%)  Bushido::Position::Vpos.lookup
# >>       35  (   47.3%)  Bushido::Position::Hpos.lookup
# >>   code:
# >>                                   |    73  |         def lookup(value)
# >>    57    (6.9%) /    57   (6.9%)  |    74  |           if value.kind_of?(Base)
# >>     2    (0.2%) /     2   (0.2%)  |    75  |             return value
# >>                                   |    76  |           end
# >>     4    (0.5%) /     4   (0.5%)  |    77  |           if value.kind_of?(String)
# >>                                   |    78  |             value = units_set[value]
# >>                                   |    79  |           end
# >>                                   |    80  |           if value
# >>     5    (0.6%) /     5   (0.6%)  |    81  |             @instance ||= {}
# >>     6    (0.7%) /     6   (0.7%)  |    82  |             @instance[value] ||= new(value).freeze
# >>                                   |    83  |           end
