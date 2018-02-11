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
# system "stackprof stackprof.dump --method Warabi::Movabler#moved_list"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 3435.8 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 1046 (0.00% miss rate)
# >>   GC: 203 (19.41%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        203  (19.4%)         203  (19.4%)     (garbage collection)
# >>         85   (8.1%)          82   (7.8%)     Warabi::Position::Base.lookup
# >>         72   (6.9%)          69   (6.6%)     Hash#transform_keys
# >>         62   (5.9%)          62   (5.9%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>         47   (4.5%)          47   (4.5%)     block (4 levels) in memory_record
# >>        150  (14.3%)          34   (3.3%)     ActiveModel::AttributeAssignment#assign_attributes
# >>        142  (13.6%)          34   (3.3%)     Warabi::Point.lookup
# >>         31   (3.0%)          29   (2.8%)     Warabi::PieceVector#all_vectors
# >>         26   (2.5%)          26   (2.5%)     Warabi::Parser::Base::ConverterMethods#clock_exist?
# >>         41   (3.9%)          26   (2.5%)     Warabi::Parser#file_parse
# >>         24   (2.3%)          24   (2.3%)     Warabi::Point#to_xy
# >>        373  (35.7%)          22   (2.1%)     Warabi::Runner#execute
# >>         18   (1.7%)          18   (1.7%)     Warabi::Soldier#attributes
# >>         29   (2.8%)          18   (1.7%)     Warabi::Point#hash
# >>         14   (1.3%)          14   (1.3%)     ActiveSupport::Duration#initialize
# >>         14   (1.3%)          14   (1.3%)     Warabi::Position::Base.value_range
# >>         13   (1.2%)          13   (1.2%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>         11   (1.1%)          11   (1.1%)     Warabi::Parser::Base::ConverterMethods#mb_ljust
# >>         11   (1.1%)          11   (1.1%)     Warabi::Piece::VectorMethods#piece_vector
# >>         12   (1.1%)          11   (1.1%)     Warabi::Position::Hpos#number_format
# >>         10   (1.0%)          10   (1.0%)     #<Module:0x00007fe729148ad0>.kconv
# >>          9   (0.9%)           9   (0.9%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         50   (4.8%)           9   (0.9%)     Warabi::Position::Hpos.lookup
# >>        241  (23.0%)           9   (0.9%)     Warabi::Movabler#moved_list
# >>        117  (11.2%)           9   (0.9%)     Set#each
# >>          8   (0.8%)           8   (0.8%)     Warabi::Point#initialize
# >>         19   (1.8%)           8   (0.8%)     Warabi::Point#eql?
# >>        586  (56.0%)           7   (0.7%)     Warabi::Mediator::Executer#execute
# >>          7   (0.7%)           7   (0.7%)     Warabi::HandLog::OfficialFormatter#initialize
# >>         54   (5.2%)           6   (0.6%)     Warabi::Position::Vpos.lookup
# >> Warabi::SkillMonitor#execute_one (/Users/ikeda/src/warabi/lib/warabi/skill_monitor.rb:19)
# >>   samples:     3 self (0.3%)  /     55 total (5.3%)
# >>   callers:
# >>       66  (  120.0%)  Warabi::SkillMonitor#execute_one
# >>       55  (  100.0%)  Warabi::SkillMonitor#execute
# >>   callees (52 total):
# >>       66  (  126.9%)  Warabi::SkillMonitor#execute_one
# >>       12  (   23.1%)  Warabi::SkillMonitor#soldier_exist?
# >>        7  (   13.5%)  block (4 levels) in memory_record
# >>        6  (   11.5%)  Warabi::BoardParser::Base#location_adjust
# >>        5  (    9.6%)  Warabi::DefenseInfo#board_parser
# >>        3  (    5.8%)  Warabi::AttackInfo#board_parser
# >>        3  (    5.8%)  Warabi::DefenseInfo::AttackInfoSharedMethods#hold_piece_in2
# >>        3  (    5.8%)  Warabi::BoardParser::FireBoardParser#other_objects_loc_ary
# >>        2  (    3.8%)  Warabi::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        2  (    3.8%)  Warabi::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        2  (    3.8%)  Warabi::Player::SkillMonitorMethods#skill_set
# >>        2  (    3.8%)  Warabi::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in2
# >>        1  (    1.9%)  Warabi::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq2
# >>        1  (    1.9%)  Warabi::SkillSet#attack_infos
# >>        1  (    1.9%)  Warabi::SkillMonitor#location
# >>        1  (    1.9%)  Warabi::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        1  (    1.9%)  Warabi::Point#hash
# >>   code:
# >>                                   |    19  |     def execute_one(e)
# >>    53    (5.1%)                   |    20  |       catch :skip do
# >>                                   |    21  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     6    (0.6%)                   |    22  |         list = player.skill_set.public_send(e.tactic_info.list_key)
# >>                                   |    23  |         if list.include?(e)
# >>                                   |    24  |           throw :skip
# >>                                   |    25  |         end
# >>                                   |    26  | 
# >>                                   |    27  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>     2    (0.2%)                   |    28  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    29  |           throw :skip
# >>                                   |    30  |         end
# >>                                   |    31  | 
# >>                                   |    32  |         # 手数制限。制限を超えていたらskip
# >>     1    (0.1%)                   |    33  |         if e.turn_limit
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
# >>     2    (0.2%)                   |    47  |         if e.order_key
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
# >>     1    (0.1%)                   |    61  |         if e.stroke_only
# >>                                   |    62  |           if origin_soldier
# >>                                   |    63  |             throw :skip
# >>                                   |    64  |           end
# >>                                   |    65  |         end
# >>                                   |    66  | 
# >>                                   |    67  |         # 駒を取ったとき制限。取ってないならskip
# >>     2    (0.2%) /     1   (0.1%)  |    68  |         if e.kill_only
# >>                                   |    69  |           unless player.runner.killed_piece
# >>                                   |    70  |             throw :skip
# >>                                   |    71  |           end
# >>                                   |    72  |         end
# >>                                   |    73  | 
# >>                                   |    74  |         # 所持駒数一致制限。異なっていたらskip
# >>                                   |    75  |         if v = e.hold_piece_count_eq
# >>                                   |    76  |           if player.pieces.size != v
# >>                                   |    77  |             throw :skip
# >>                                   |    78  |           end
# >>                                   |    79  |         end
# >>                                   |    80  | 
# >>                                   |    81  |         if true
# >>                                   |    82  |           # 何もない制限。何かあればskip
# >>     8    (0.8%)                   |    83  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["○"]
# >>     1    (0.1%)                   |    84  |             ary.each do |e|
# >>     1    (0.1%)                   |    85  |               if surface[e[:point]]
# >>                                   |    86  |                 throw :skip
# >>                                   |    87  |               end
# >>                                   |    88  |             end
# >>                                   |    89  |           end
# >>                                   |    90  | 
# >>                                   |    91  |           # 何かある制限。何もなければskip
# >>     1    (0.1%)                   |    92  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["●"]
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
# >>     2    (0.2%)                   |   103  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["☆"]
# >>                                   |   104  |             # 移動元についての指定があるのに移動元がない場合はそもそも状況が異なるのでskip
# >>                                   |   105  |             unless origin_soldier
# >>                                   |   106  |               throw :skip
# >>                                   |   107  |             end
# >>                                   |   108  |             ary.each do |e|
# >>                                   |   109  |               if e[:point] == origin_soldier.point
# >>                                   |   110  |                 throw :skip
# >>                                   |   111  |               end
# >>                                   |   112  |             end
# >>                                   |   113  |           end
# >>                                   |   114  | 
# >>                                   |   115  |           # 移動元である(any条件)。どの移動元にも該当しなかったらskip
# >>     2    (0.2%)                   |   116  |           if points_hash = e.board_parser.other_objects_loc_points_hash[location.key]["★"]
# >>                                   |   117  |             # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   118  |             unless origin_soldier
# >>                                   |   119  |               throw :skip
# >>                                   |   120  |             end
# >>                                   |   121  |             if points_hash[origin_soldier.point]
# >>                                   |   122  |               # 移動元があったのでOK
# >>                                   |   123  |             else
# >>                                   |   124  |               throw :skip
# >>                                   |   125  |             end
# >>                                   |   126  |           end
# >>                                   |   127  |         end
# >>                                   |   128  | 
# >>                                   |   129  |         # 歩を持っていたらskip
# >>                                   |   130  |         if e.not_have_pawn
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
# >>     3    (0.3%)                   |   152  |           if v = e.hold_piece_in2
# >>                                   |   153  |             if v.all? {|e| pieces_hash.has_key?(e) }
# >>                                   |   154  |             else
# >>                                   |   155  |               throw :skip
# >>                                   |   156  |             end
# >>                                   |   157  |           end
# >>                                   |   158  | 
# >>                                   |   159  |           # 指定の駒をどれか含んでいるならskip
# >>     2    (0.2%)                   |   160  |           if v = e.hold_piece_not_in2
# >>                                   |   161  |             if v.any? {|e| pieces_hash.has_key?(e) }
# >>                                   |   162  |               throw :skip
# >>                                   |   163  |             end
# >>                                   |   164  |           end
# >>                                   |   165  |         end
# >>                                   |   166  | 
# >>                                   |   167  |         # どれかが盤上に正確に含まれるならOK
# >>                                   |   168  |         if ary = e.board_parser.any_exist_soldiers_loc[location.key].presence
# >>     4    (0.4%)                   |   169  |           if ary.any? { |e| soldier_exist?(e) }
# >>                                   |   170  |           else
# >>                                   |   171  |             throw :skip
# >>                                   |   172  |           end
# >>                                   |   173  |         end
# >>                                   |   174  | 
# >>                                   |   175  |         # 指定の配置が盤上に含まれるならOK
# >>     7    (0.7%)                   |   176  |         ary = e.board_parser.location_adjust[location.key]
# >>    20    (1.9%)                   |   177  |         if ary.all? { |e| soldier_exist?(e) }
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
# >>   samples:     0 self (0.0%)  /    144 total (13.8%)
# >>   callers:
# >>      144  (  100.0%)  Warabi::Player#execute
# >>       55  (   38.2%)  Warabi::SkillMonitor#execute
# >>   callees (144 total):
# >>       63  (   43.8%)  Warabi::TacticInfo.soldier_hash_table
# >>       55  (   38.2%)  Warabi::SkillMonitor#execute_one
# >>       55  (   38.2%)  Warabi::SkillMonitor#execute
# >>       20  (   13.9%)  Warabi::SkillMonitor#current_soldier
# >>        5  (    3.5%)  Warabi::Soldier#hash
# >>        1  (    0.7%)  Warabi::Soldier#eql?
# >>   code:
# >>                                   |    11  |     def execute
# >>    89    (8.5%)                   |    12  |       if e = TacticInfo.soldier_hash_table[current_soldier]
# >>   110   (10.5%)                   |    13  |         e.each { |e| execute_one(e) }
# >>                                   |    14  |       end
# >> Warabi::Position::Base.lookup (/Users/ikeda/src/warabi/lib/warabi/position.rb:73)
# >>   samples:    82 self (7.8%)  /     85 total (8.1%)
# >>   callers:
# >>       44  (   51.8%)  Warabi::Position::Vpos.lookup
# >>       41  (   48.2%)  Warabi::Position::Hpos.lookup
# >>   callees (3 total):
# >>        3  (  100.0%)  Warabi::Position::Base.units_set
# >>   code:
# >>                                   |    73  |         def lookup(value)
# >>    65    (6.2%) /    65   (6.2%)  |    74  |           if value.kind_of?(Base)
# >>     2    (0.2%) /     2   (0.2%)  |    75  |             return value
# >>                                   |    76  |           end
# >>     2    (0.2%) /     2   (0.2%)  |    77  |           if value.kind_of?(String)
# >>     3    (0.3%)                   |    78  |             value = units_set[value]
# >>                                   |    79  |           end
# >>                                   |    80  |           if value
# >>     7    (0.7%) /     7   (0.7%)  |    81  |             @instance ||= {}
# >>     5    (0.5%) /     5   (0.5%)  |    82  |             @instance[value] ||= new(value).freeze
# >>                                   |    83  |           end
# >>     1    (0.1%) /     1   (0.1%)  |    84  |         end
# >>                                   |    85  | 
