require "./example_helper"

# Warabi.config[:skill_set_flag] = false

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
system "stackprof stackprof.dump --method Warabi::SkillMonitor#execute"
system "stackprof stackprof.dump --method Warabi::Position::Base.lookup"

# system "stackprof stackprof.dump --method Warabi::Point.fetch"
# system "stackprof stackprof.dump --method Warabi::Movabler#movable_infos"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 2840.7 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 987 (0.00% miss rate)
# >>   GC: 269 (27.25%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        269  (27.3%)         269  (27.3%)     (garbage collection)
# >>         79   (8.0%)          77   (7.8%)     Warabi::Position::Base.lookup
# >>         47   (4.8%)          47   (4.8%)     block (4 levels) in memory_record
# >>         39   (4.0%)          39   (4.0%)     Warabi::Point#to_xy
# >>        134  (13.6%)          36   (3.6%)     Warabi::Point.lookup
# >>         41   (4.2%)          28   (2.8%)     Warabi::Parser#file_parse
# >>         26   (2.6%)          26   (2.6%)     Warabi::Battler#to_soldier
# >>        287  (29.1%)          21   (2.1%)     Warabi::Runner#execute
# >>         18   (1.8%)          18   (1.8%)     Hash#slice
# >>         69   (7.0%)          17   (1.7%)     Warabi::Movabler#alive_piece?
# >>         17   (1.7%)          16   (1.6%)     Warabi::Piece::VectorMethods#select_vectors2
# >>         27   (2.7%)          15   (1.5%)     Warabi::Point#hash
# >>         53   (5.4%)          13   (1.3%)     Warabi::Position::Hpos.lookup
# >>         12   (1.2%)          12   (1.2%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         14   (1.4%)          12   (1.2%)     Hash#transform_keys
# >>         11   (1.1%)          11   (1.1%)     ActiveSupport::Duration#initialize
# >>         11   (1.1%)          11   (1.1%)     Warabi::Position::Hpos#number_format
# >>         17   (1.7%)          11   (1.1%)     Warabi::Piece::NameMethods#basic_names
# >>         10   (1.0%)          10   (1.0%)     Warabi::HandLog#initialize
# >>         10   (1.0%)          10   (1.0%)     Warabi::Parser::Base::ConverterMethods#mb_ljust
# >>         10   (1.0%)          10   (1.0%)     Warabi::Position::Base.value_range
# >>         65   (6.6%)          10   (1.0%)     Set#each
# >>          9   (0.9%)           9   (0.9%)     Warabi::HandLog::OfficialFormatter#initialize
# >>        428  (43.4%)           8   (0.8%)     Warabi::Mediator::Executer#execute
# >>         17   (1.7%)           7   (0.7%)     Warabi::Position::Base#valid?
# >>         28   (2.8%)           6   (0.6%)     Warabi::Point#eql?
# >>         18   (1.8%)           6   (0.6%)     <top (required)>
# >>          6   (0.6%)           6   (0.6%)     Hash#assert_valid_keys
# >>          8   (0.8%)           6   (0.6%)     Warabi::Position::Vpos#number_format
# >>          5   (0.5%)           5   (0.5%)     Warabi::Position::Vpos._units
# >> Warabi::SkillMonitor#execute_one (/Users/ikeda/src/warabi/lib/warabi/skill_monitor.rb:19)
# >>   samples:     5 self (0.5%)  /     36 total (3.6%)
# >>   callers:
# >>       37  (  102.8%)  Warabi::SkillMonitor#execute_one
# >>       36  (  100.0%)  Warabi::SkillMonitor#execute
# >>   callees (31 total):
# >>       37  (  119.4%)  Warabi::SkillMonitor#execute_one
# >>        8  (   25.8%)  Warabi::DefenseInfo#board_parser
# >>        6  (   19.4%)  Warabi::AttackInfo#board_parser
# >>        5  (   16.1%)  block (4 levels) in memory_record
# >>        3  (    9.7%)  Warabi::SkillMonitor#battler_exist?
# >>        2  (    6.5%)  Warabi::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        2  (    6.5%)  Warabi::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        1  (    3.2%)  Warabi::SkillSet#attack_infos
# >>        1  (    3.2%)  Object#presence
# >>        1  (    3.2%)  Warabi::SkillMonitor#location
# >>        1  (    3.2%)  Warabi::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq2
# >>        1  (    3.2%)  Warabi::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>   code:
# >>                                   |    19  |     def execute_one(e)
# >>    34    (3.4%)                   |    20  |       catch :skip do
# >>                                   |    21  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     5    (0.5%)                   |    22  |         list = player.skill_set.public_send(e.tactic_info.list_key)
# >>                                   |    23  |         if list.include?(e)
# >>                                   |    24  |           throw :skip
# >>                                   |    25  |         end
# >>                                   |    26  | 
# >>                                   |    27  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>     1    (0.1%)                   |    28  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    29  |           throw :skip
# >>                                   |    30  |         end
# >>                                   |    31  | 
# >>                                   |    32  |         # 手数制限。制限を超えていたらskip
# >>     2    (0.2%)                   |    33  |         if e.turn_limit
# >>                                   |    34  |           if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    35  |             throw :skip
# >>                                   |    36  |           end
# >>                                   |    37  |         end
# >>                                   |    38  | 
# >>                                   |    39  |         # 手数限定。手数が異なっていたらskip
# >>                                   |    40  |         if e.turn_eq
# >>                                   |    41  |           if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    42  |             throw :skip
# >>                                   |    43  |           end
# >>                                   |    44  |         end
# >>                                   |    45  | 
# >>                                   |    46  |         # 手番限定。手番が異なればskip
# >>     1    (0.1%)                   |    47  |         if e.order_key
# >>                                   |    48  |           if e.order_key != player.mediator.turn_info.order_key
# >>                                   |    49  |             throw :skip
# >>                                   |    50  |           end
# >>                                   |    51  |         end
# >>                                   |    52  | 
# >>                                   |    53  |         # 開戦済みならskip
# >>                                   |    54  |         if e.cold_war
# >>                                   |    55  |           if player.mediator.kill_counter.positive?
# >>                                   |    56  |             throw :skip
# >>                                   |    57  |           end
# >>                                   |    58  |         end
# >>                                   |    59  | 
# >>                                   |    60  |         # 「打」時制限。移動元駒があればskip
# >>                                   |    61  |         if e.stroke_only
# >>                                   |    62  |           if before_soldier
# >>                                   |    63  |             throw :skip
# >>                                   |    64  |           end
# >>                                   |    65  |         end
# >>                                   |    66  | 
# >>                                   |    67  |         # 駒を取ったとき制限。取ってないならskip
# >>                                   |    68  |         if e.kill_only
# >>                                   |    69  |           unless player.runner.killed_piece
# >>                                   |    70  |             throw :skip
# >>                                   |    71  |           end
# >>                                   |    72  |         end
# >>                                   |    73  | 
# >>                                   |    74  |         # 所持駒数一致制限。異なっていたらskip
# >>     1    (0.1%)                   |    75  |         if v = e.hold_piece_count_eq
# >>                                   |    76  |           if player.pieces.size != v
# >>                                   |    77  |             throw :skip
# >>                                   |    78  |           end
# >>                                   |    79  |         end
# >>                                   |    80  | 
# >>                                   |    81  |         if true
# >>                                   |    82  |           # 何もない制限。何かあればskip
# >>     3    (0.3%) /     1   (0.1%)  |    83  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["○"]
# >>                                   |    84  |             ary.each do |e|
# >>                                   |    85  |               if surface[e[:point]]
# >>                                   |    86  |                 throw :skip
# >>                                   |    87  |               end
# >>                                   |    88  |             end
# >>                                   |    89  |           end
# >>                                   |    90  | 
# >>                                   |    91  |           # 何かある制限。何もなければskip
# >>     2    (0.2%)                   |    92  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["●"]
# >>                                   |    93  |             ary.each do |e|
# >>                                   |    94  |               if !surface[e[:point]]
# >>                                   |    95  |                 throw :skip
# >>                                   |    96  |               end
# >>                                   |    97  |             end
# >>                                   |    98  |           end
# >>                                   |    99  |         end
# >>                                   |   100  | 
# >>                                   |   101  |         if true
# >>                                   |   102  |           # 移動元ではない制限。移動元だったらskip
# >>     5    (0.5%) /     1   (0.1%)  |   103  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["☆"]
# >>                                   |   104  |             # 移動元についての指定があるのに移動元がない場合はそもそも状況が異なるのでskip
# >>                                   |   105  |             unless before_soldier
# >>                                   |   106  |               throw :skip
# >>                                   |   107  |             end
# >>                                   |   108  |             ary.each do |e|
# >>                                   |   109  |               if e[:point] == before_soldier.point
# >>                                   |   110  |                 throw :skip
# >>                                   |   111  |               end
# >>                                   |   112  |             end
# >>                                   |   113  |           end
# >>                                   |   114  | 
# >>                                   |   115  |           # 移動元である(any条件)。どの移動元にも該当しなかったらskip
# >>     2    (0.2%) /     1   (0.1%)  |   116  |           if points_hash = e.board_parser.other_objects_loc_points_hash[location.key]["★"]
# >>                                   |   117  |             # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   118  |             unless before_soldier
# >>                                   |   119  |               throw :skip
# >>                                   |   120  |             end
# >>                                   |   121  |             if points_hash[before_soldier.point]
# >>                                   |   122  |               # 移動元があったのでOK
# >>                                   |   123  |             else
# >>                                   |   124  |               throw :skip
# >>                                   |   125  |             end
# >>                                   |   126  |           end
# >>                                   |   127  |         end
# >>                                   |   128  | 
# >>                                   |   129  |         # 歩を持っていたらskip
# >>     1    (0.1%)                   |   130  |         if e.not_have_pawn
# >>                                   |   131  |           if pieces_hash.has_key?(:pawn)
# >>                                   |   132  |             throw :skip
# >>                                   |   133  |           end
# >>                                   |   134  |         end
# >>                                   |   135  | 
# >>                                   |   136  |         # 歩を除いて何か持っていたらskip
# >>                                   |   137  |         if e.not_have_anything_except_pawn
# >>                                   |   138  |           if !pieces_hash.except(:pawn).empty?
# >>                                   |   139  |             throw :skip
# >>                                   |   140  |           end
# >>                                   |   141  |         end
# >>                                   |   142  | 
# >>                                   |   143  |         if true
# >>                                   |   144  |           # 駒が一致していなければskip
# >>     1    (0.1%)                   |   145  |           if v = e.hold_piece_eq2
# >>                                   |   146  |             if pieces_hash != v
# >>                                   |   147  |               throw :skip
# >>                                   |   148  |             end
# >>                                   |   149  |           end
# >>                                   |   150  | 
# >>                                   |   151  |           # 指定の駒をすべて含んでいるならOK
# >>                                   |   152  |           if v = e.hold_piece_in2
# >>                                   |   153  |             if v.all? {|e| pieces_hash.has_key?(e) }
# >>                                   |   154  |             else
# >>                                   |   155  |               throw :skip
# >>                                   |   156  |             end
# >>                                   |   157  |           end
# >>                                   |   158  | 
# >>                                   |   159  |           # 指定の駒をどれか含んでいるならskip
# >>                                   |   160  |           if v = e.hold_piece_not_in2
# >>                                   |   161  |             if v.any? {|e| pieces_hash.has_key?(e) }
# >>                                   |   162  |               throw :skip
# >>                                   |   163  |             end
# >>                                   |   164  |           end
# >>                                   |   165  |         end
# >>                                   |   166  | 
# >>                                   |   167  |         # どれかが盤上に正確に含まれるならOK
# >>     5    (0.5%)                   |   168  |         if ary = e.board_parser.any_exist_soldiers_loc[location.key].presence
# >>                                   |   169  |           if ary.any? { |e| battler_exist?(e) }
# >>                                   |   170  |           else
# >>                                   |   171  |             throw :skip
# >>                                   |   172  |           end
# >>                                   |   173  |         end
# >>                                   |   174  | 
# >>                                   |   175  |         # 指定の配置が盤上に含まれるならOK
# >>     2    (0.2%)                   |   176  |         ary = e.board_parser.soldiers_hash_loc[location.key]
# >>     6    (0.6%)                   |   177  |         if ary.all? { |e| battler_exist?(e) }
# >>                                   |   178  |         else
# >>                                   |   179  |           throw :skip
# >>                                   |   180  |         end
# >>                                   |   181  | 
# >>                                   |   182  |         list << e
# >>                                   |   183  |         player.runner.skill_set.public_send(e.tactic_info.list_key) << e
# >>                                   |   184  |       end
# >>     2    (0.2%) /     2   (0.2%)  |   185  |     end
# >>                                   |   186  | 
# >> Warabi::SkillMonitor#execute (/Users/ikeda/src/warabi/lib/warabi/skill_monitor.rb:11)
# >>   samples:     1 self (0.1%)  /    102 total (10.3%)
# >>   callers:
# >>      102  (  100.0%)  Warabi::Player#execute
# >>       36  (   35.3%)  Warabi::SkillMonitor#execute
# >>   callees (101 total):
# >>       57  (   56.4%)  Warabi::TacticInfo.soldier_hash_table
# >>       36  (   35.6%)  Warabi::SkillMonitor#execute_one
# >>       36  (   35.6%)  Warabi::SkillMonitor#execute
# >>        7  (    6.9%)  Warabi::SkillMonitor#current_soldier
# >>        1  (    1.0%)  Warabi::Point#hash
# >>   code:
# >>                                   |    11  |     def execute
# >>    66    (6.7%) /     1   (0.1%)  |    12  |       if e = TacticInfo.soldier_hash_table[current_soldier]
# >>    72    (7.3%)                   |    13  |         e.each { |e| execute_one(e) }
# >>                                   |    14  |       end
# >> Warabi::Position::Base.lookup (/Users/ikeda/src/warabi/lib/warabi/position.rb:73)
# >>   samples:    77 self (7.8%)  /     79 total (8.0%)
# >>   callers:
# >>       40  (   50.6%)  Warabi::Position::Hpos.lookup
# >>       39  (   49.4%)  Warabi::Position::Vpos.lookup
# >>   callees (2 total):
# >>        2  (  100.0%)  Warabi::Position::Base.units_set
# >>   code:
# >>                                   |    73  |         def lookup(value)
# >>    68    (6.9%) /    68   (6.9%)  |    74  |           if value.kind_of?(Base)
# >>     2    (0.2%) /     2   (0.2%)  |    75  |             return value
# >>                                   |    76  |           end
# >>                                   |    77  |           if value.kind_of?(String)
# >>     2    (0.2%)                   |    78  |             value = units_set[value]
# >>                                   |    79  |           end
# >>                                   |    80  |           if value
# >>     3    (0.3%) /     3   (0.3%)  |    81  |             @instance ||= {}
# >>     4    (0.4%) /     4   (0.4%)  |    82  |             @instance[value] ||= new(value).freeze
# >>                                   |    83  |           end
