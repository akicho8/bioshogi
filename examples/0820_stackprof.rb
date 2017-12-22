require "./example_helper"

# Bushido.config[:skill_set_flag] = false

require "stackprof"

ms = Benchmark.ms do
  StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
    # StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
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

# >> 3046.1 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 886 (0.00% miss rate)
# >>   GC: 171 (19.30%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        171  (19.3%)         171  (19.3%)     (garbage collection)
# >>         84   (9.5%)          83   (9.4%)     Bushido::Position::Base.lookup
# >>         39   (4.4%)          39   (4.4%)     block (4 levels) in memory_record
# >>        132  (14.9%)          37   (4.2%)     Bushido::Point.lookup
# >>         31   (3.5%)          31   (3.5%)     Bushido::Point#to_xy
# >>         42   (4.7%)          28   (3.2%)     Bushido::Parser#file_parse
# >>         24   (2.7%)          24   (2.7%)     Hash#slice
# >>         24   (2.7%)          24   (2.7%)     Bushido::Piece::VectorMethods#select_vectors2
# >>         80   (9.0%)          20   (2.3%)     Bushido::Movabler#piece_store
# >>        249  (28.1%)          15   (1.7%)     Bushido::Runner#execute
# >>         17   (1.9%)          13   (1.5%)     Hash#transform_keys
# >>         11   (1.2%)          11   (1.2%)     #<Module:0x007ff35d271138>.kconv
# >>         14   (1.6%)          11   (1.2%)     Bushido::Parser::Base::ConverterMethods#clock_exist?
# >>         10   (1.1%)          10   (1.1%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         10   (1.1%)          10   (1.1%)     Bushido::Battler#to_soldier
# >>         11   (1.2%)           9   (1.0%)     ActiveSupport::Duration::Scalar#-
# >>        134  (15.1%)           9   (1.0%)     Bushido::Movabler#movable_infos
# >>          9   (1.0%)           9   (1.0%)     ActiveSupport::Duration#initialize
# >>          8   (0.9%)           8   (0.9%)     Bushido::HandLog#initialize
# >>          8   (0.9%)           8   (0.9%)     Bushido::Parser::Base::ConverterMethods#mb_ljust
# >>         16   (1.8%)           8   (0.9%)     Bushido::Position::Base#valid?
# >>         55   (6.2%)           8   (0.9%)     Bushido::SkillMonitor#execute_one
# >>         10   (1.1%)           8   (0.9%)     Bushido::Piece::NameMethods#basic_names
# >>          8   (0.9%)           8   (0.9%)     Bushido::Position::Base.value_range
# >>         25   (2.8%)           8   (0.9%)     Bushido::Point#hash
# >>         16   (1.8%)           7   (0.8%)     Bushido::Point#eql?
# >>         74   (8.4%)           7   (0.8%)     Bushido::BoardParser::KifBoardParser#cell_walker
# >>          8   (0.9%)           7   (0.8%)     Bushido::Position::Vpos#number_format
# >>         52   (5.9%)           6   (0.7%)     Bushido::Position::Vpos.lookup
# >>         22   (2.5%)           6   (0.7%)     MemoryRecord::SingletonMethods::ClassMethods#each
# >> Bushido::SkillMonitor#execute_one (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:16)
# >>   samples:     8 self (0.9%)  /     55 total (6.2%)
# >>   callers:
# >>       69  (  125.5%)  Bushido::SkillMonitor#execute_one
# >>       55  (  100.0%)  Bushido::SkillMonitor#execute
# >>   callees (47 total):
# >>       69  (  146.8%)  Bushido::SkillMonitor#execute_one
# >>       10  (   21.3%)  Bushido::SkillMonitor#on_board_soldiers3
# >>        7  (   14.9%)  block (4 levels) in memory_record
# >>        6  (   12.8%)  Bushido::DefenseInfo#board_parser
# >>        5  (   10.6%)  Bushido::BoardParser::FireBoardParser#other_objects_loc_ary
# >>        5  (   10.6%)  Bushido::AttackInfo#board_parser
# >>        3  (    6.4%)  Bushido::BoardParser::FireBoardParser#other_objects_loc_points_hash
# >>        2  (    4.3%)  Bushido::TacticInfo#var_key
# >>        2  (    4.3%)  Bushido::Player::SkillMonitorMethods#skill_set
# >>        2  (    4.3%)  Bushido::Point#hash
# >>        1  (    2.1%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        1  (    2.1%)  Bushido::TurnInfo#order_key
# >>        1  (    2.1%)  Bushido::Soldier#point
# >>        1  (    2.1%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        1  (    2.1%)  Bushido::BoardParser::FireBoardParser#any_exist_soldiers_loc
# >>   code:
# >>                                   |    16  |     def execute_one(e)
# >>    55    (6.2%) /     1   (0.1%)  |    17  |       catch :skip do
# >>                                   |    18  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     6    (0.7%)                   |    19  |         list = player.skill_set.public_send(e.tactic_info.var_key)
# >>     1    (0.1%) /     1   (0.1%)  |    20  |         if list.include?(e)
# >>                                   |    21  |           throw :skip
# >>                                   |    22  |         end
# >>                                   |    23  | 
# >>                                   |    24  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>     1    (0.1%) /     1   (0.1%)  |    25  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    26  |           throw :skip
# >>                                   |    27  |         end
# >>                                   |    28  | 
# >>                                   |    29  |         if e.turn_limit
# >>                                   |    30  |           if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    31  |             throw :skip
# >>                                   |    32  |           end
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>     1    (0.1%)                   |    35  |         if e.turn_eq
# >>                                   |    36  |           if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    37  |             throw :skip
# >>                                   |    38  |           end
# >>                                   |    39  |         end
# >>                                   |    40  | 
# >>                                   |    41  |         if e.order_key
# >>     1    (0.1%)                   |    42  |           if e.order_key != player.mediator.turn_info.order_key
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
# >>                                   |    59  |         if e.kill_only
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
# >>    10    (1.1%) /     1   (0.1%)  |    73  |           if ary = e.board_parser.other_objects_loc_ary[player.location.key]["○"]
# >>     5    (0.6%)                   |    74  |             ary.each do |v|
# >>     5    (0.6%) /     4   (0.5%)  |    75  |               if surface[v]
# >>                                   |    76  |                 throw :skip
# >>                                   |    77  |               end
# >>                                   |    78  |             end
# >>                                   |    79  |           end
# >>                                   |    80  |           # 何かある
# >>     3    (0.3%)                   |    81  |           if ary = e.board_parser.other_objects_loc_ary[player.location.key]["●"]
# >>                                   |    82  |             ary.each do |e|
# >>                                   |    83  |               if !surface[e[:point]]
# >>                                   |    84  |                 throw :skip
# >>                                   |    85  |               end
# >>                                   |    86  |             end
# >>                                   |    87  |           end
# >>                                   |    88  | 
# >>                                   |    89  |           # 移動元ではない
# >>     4    (0.5%)                   |    90  |           if ary = e.board_parser.other_objects_loc_ary[player.location.key]["☆"]
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
# >>     4    (0.5%)                   |   103  |           if points_hash = e.board_parser.other_objects_loc_points_hash[player.location.key]["★"]
# >>                                   |   104  |             # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   105  |             unless before_soldier
# >>                                   |   106  |               throw :skip
# >>                                   |   107  |             end
# >>     2    (0.2%)                   |   108  |             if points_hash[before_soldier.point]
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
# >>     1    (0.1%)                   |   165  |         if e.not_have_pawn
# >>                                   |   166  |           if player_pieces_sort_hash.has_key?(:pawn)
# >>                                   |   167  |             throw :skip
# >>                                   |   168  |           end
# >>                                   |   169  |         end
# >>                                   |   170  | 
# >>                                   |   171  |         if e.not_have_anything_except_pawn
# >>                                   |   172  |           if player_pieces_sort_hash.except(:pawn).empty?
# >>                                   |   173  |             throw :skip
# >>                                   |   174  |           end
# >>                                   |   175  |         end
# >>                                   |   176  | 
# >>                                   |   177  |         if v = e.hold_piece_eq
# >>                                   |   178  |           if player_pieces_sort_hash != v
# >>                                   |   179  |             throw :skip
# >>                                   |   180  |           end
# >>                                   |   181  |         end
# >>                                   |   182  | 
# >>                                   |   183  |         # 指定の駒をすべて持っているならOK
# >>                                   |   184  |         if v = e.hold_piece_in
# >>                                   |   185  |           if v.all? {|e| player_pieces_sort_hash.has_key?(e) }
# >>                                   |   186  |           else
# >>                                   |   187  |             throw :skip
# >>                                   |   188  |           end
# >>                                   |   189  |         end
# >>                                   |   190  | 
# >>                                   |   191  |         # 指定の駒をどれか持っていたらskip
# >>                                   |   192  |         if v = e.hold_piece_not_in
# >>                                   |   193  |           if v.any? {|e| player_pieces_sort_hash.has_key?(e) }
# >>                                   |   194  |             throw :skip
# >>                                   |   195  |           end
# >>                                   |   196  |         end
# >>                                   |   197  | 
# >>                                   |   198  |         if true
# >>                                   |   199  |           # どれかが盤上に含まれる(駒の一致も確認)
# >>     2    (0.2%)                   |   200  |           if ary = e.board_parser.any_exist_soldiers_loc[player.location.key].presence
# >>                                   |   201  |             if ary.any? { |e| on_board_soldiers3(e) }
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
# >>     2    (0.2%)                   |   219  |           ary = e.board_parser.soldiers_hash_loc[player.location.key]
# >>                                   |   220  |           # if ary.all? { |e| on_board_soldiers2.include?(e) }
# >>    20    (2.3%)                   |   221  |           if ary.all? { |e| on_board_soldiers3(e) }
# >>                                   |   222  |           else
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:     6 self (0.7%)  /    138 total (15.6%)
# >>   callers:
# >>      138  (  100.0%)  Bushido::Player#execute
# >>       55  (   39.9%)  Bushido::SkillMonitor#execute
# >>   callees (132 total):
# >>       65  (   49.2%)  Bushido::TacticInfo.soldier_hash_table
# >>       55  (   41.7%)  Bushido::SkillMonitor#execute_one
# >>       55  (   41.7%)  Bushido::SkillMonitor#execute
# >>        7  (    5.3%)  Bushido::SkillMonitor#current_soldier
# >>        4  (    3.0%)  Bushido::Point#hash
# >>        1  (    0.8%)  Bushido::Point#eql?
# >>   code:
# >>                                   |    11  |     def execute
# >>    83    (9.4%) /     6   (0.7%)  |    12  |       elements = TacticInfo.soldier_hash_table[current_soldier] || []
# >>   110   (12.4%)                   |    13  |       elements.each { |e| execute_one(e) }
# >>                                   |    14  |     end
# >> Bushido::Position::Base.lookup (/Users/ikeda/src/bushido/lib/bushido/position.rb:73)
# >>   samples:    83 self (9.4%)  /     84 total (9.5%)
# >>   callers:
# >>       42  (   50.0%)  Bushido::Position::Hpos.lookup
# >>       42  (   50.0%)  Bushido::Position::Vpos.lookup
# >>   callees (1 total):
# >>        1  (  100.0%)  Bushido::Position::Base.units_set
# >>   code:
# >>                                   |    73  |         def lookup(value)
# >>    71    (8.0%) /    71   (8.0%)  |    74  |           if value.kind_of?(Base)
# >>                                   |    75  |             return value
# >>                                   |    76  |           end
# >>     2    (0.2%) /     2   (0.2%)  |    77  |           if value.kind_of?(String)
# >>     1    (0.1%)                   |    78  |             value = units_set[value]
# >>                                   |    79  |           end
# >>                                   |    80  |           if value
# >>     3    (0.3%) /     3   (0.3%)  |    81  |             @instance ||= {}
# >>     7    (0.8%) /     7   (0.8%)  |    82  |             @instance[value] ||= new(value).freeze
# >>                                   |    83  |           end
