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

# >> 3566.3 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 1149 (0.00% miss rate)
# >>   GC: 250 (21.76%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        250  (21.8%)         250  (21.8%)     (garbage collection)
# >>         93   (8.1%)          92   (8.0%)     Bushido::Position::Base.lookup
# >>         49   (4.3%)          49   (4.3%)     block (4 levels) in memory_record
# >>         45   (3.9%)          45   (3.9%)     Bushido::Point#to_xy
# >>        170  (14.8%)          42   (3.7%)     Bushido::Point.lookup
# >>        130  (11.3%)          28   (2.4%)     Bushido::SkillMonitor#execute_one
# >>         27   (2.3%)          27   (2.3%)     Bushido::Piece::VectorMethods#select_vectors2
# >>         25   (2.2%)          25   (2.2%)     Bushido::Battler#to_soldier
# >>        324  (28.2%)          24   (2.1%)     Bushido::Runner#execute
# >>        100   (8.7%)          23   (2.0%)     Bushido::Movabler#piece_store
# >>         39   (3.4%)          23   (2.0%)     Bushido::Parser#file_parse
# >>         22   (1.9%)          22   (1.9%)     Hash#slice
# >>         20   (1.7%)          20   (1.7%)     Bushido::Position::Base.value_range
# >>         67   (5.8%)          16   (1.4%)     Bushido::Position::Hpos.lookup
# >>         15   (1.3%)          15   (1.3%)     Bushido::Position::Base.units
# >>         45   (3.9%)          15   (1.3%)     Bushido::Soldier#reverse
# >>         28   (2.4%)          15   (1.3%)     Bushido::Point#hash
# >>         14   (1.2%)          14   (1.2%)     Bushido::Point#initialize
# >>         57   (5.0%)          13   (1.1%)     Bushido::Position::Vpos.lookup
# >>         13   (1.1%)          13   (1.1%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         12   (1.0%)          12   (1.0%)     #<Module:0x007fae6b9382a0>.kconv
# >>         39   (3.4%)          11   (1.0%)     Bushido::Point#eql?
# >>         15   (1.3%)          11   (1.0%)     Bushido::Parser::Base::ConverterMethods#clock_exist?
# >>         10   (0.9%)          10   (0.9%)     Bushido::HandLog#initialize
# >>         10   (0.9%)          10   (0.9%)     ActiveSupport::Duration#initialize
# >>         14   (1.2%)           9   (0.8%)     Hash#transform_keys
# >>         12   (1.0%)           9   (0.8%)     Bushido::Piece::NameMethods#basic_names
# >>          8   (0.7%)           8   (0.7%)     Bushido::Parser::Base::ConverterMethods#mb_ljust
# >>         10   (0.9%)           8   (0.7%)     ActiveSupport::Duration.===
# >>         10   (0.9%)           8   (0.7%)     ActiveSupport::Duration::Scalar#-
# >> Bushido::SkillMonitor#execute_one (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:16)
# >>   samples:    28 self (2.4%)  /    130 total (11.3%)
# >>   callers:
# >>      172  (  132.3%)  Bushido::SkillMonitor#execute_one
# >>      130  (  100.0%)  Bushido::SkillMonitor#execute
# >>   callees (102 total):
# >>      172  (  168.6%)  Bushido::SkillMonitor#execute_one
# >>       49  (   48.0%)  Bushido::SkillMonitor#on_board_soldiers
# >>       13  (   12.7%)  Bushido::Point#==
# >>        8  (    7.8%)  block (4 levels) in memory_record
# >>        5  (    4.9%)  Bushido::DefenseInfo#board_parser
# >>        5  (    4.9%)  Bushido::Point#reverse_if_white
# >>        4  (    3.9%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        4  (    3.9%)  Bushido::AttackInfo#board_parser
# >>        3  (    2.9%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        2  (    2.0%)  Bushido::Player::SkillMonitorMethods#skill_set
# >>        2  (    2.0%)  Bushido::Board::ReaderMethods#[]
# >>        1  (    1.0%)  Bushido::SkillSet#defense_infos
# >>        1  (    1.0%)  Bushido::Soldier#point
# >>        1  (    1.0%)  Bushido::ApplicationMemoryRecord#<=>
# >>        1  (    1.0%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        1  (    1.0%)  Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>        1  (    1.0%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        1  (    1.0%)  Bushido::BoardParser::FireBoardParser#any_exist_soldiers
# >>   code:
# >>                                   |    16  |     def execute_one(e)
# >>   130   (11.3%) /     2   (0.2%)  |    17  |       catch :skip do
# >>                                   |    18  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     9    (0.8%)                   |    19  |         list = player.skill_set.public_send(e.tactic_info.var_key)
# >>                                   |    20  |         if list.include?(e)
# >>                                   |    21  |           throw :skip
# >>                                   |    22  |         end
# >>                                   |    23  | 
# >>                                   |    24  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>     2    (0.2%) /     1   (0.1%)  |    25  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    26  |           throw :skip
# >>                                   |    27  |         end
# >>                                   |    28  | 
# >>     2    (0.2%)                   |    29  |         if e.turn_limit
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
# >>                                   |    42  |           if e.order_key != player.mediator.turn_info.order_info
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
# >>                                   |    54  |           if player.runner.before_soldier
# >>                                   |    55  |             throw :skip
# >>                                   |    56  |           end
# >>                                   |    57  |         end
# >>                                   |    58  | 
# >>     2    (0.2%)                   |    59  |         if e.kill_only
# >>                                   |    60  |           unless player.runner.killed_piece
# >>                                   |    61  |             throw :skip
# >>                                   |    62  |           end
# >>                                   |    63  |         end
# >>                                   |    64  | 
# >>     2    (0.2%)                   |    65  |         if v = e.hold_piece_count_eq
# >>                                   |    66  |           if player.pieces.size != v
# >>                                   |    67  |             throw :skip
# >>                                   |    68  |           end
# >>                                   |    69  |         end
# >>                                   |    70  | 
# >>                                   |    71  |         # 何もない
# >>     6    (0.5%) /     1   (0.1%)  |    72  |         if ary = e.board_parser.other_objects_hash_ary["○"]
# >>     6    (0.5%)                   |    73  |           ary.each do |obj|
# >>     4    (0.3%)                   |    74  |             pt = obj[:point].reverse_if_white(player.location)
# >>     2    (0.2%)                   |    75  |             if player.board[pt]
# >>                                   |    76  |               throw :skip
# >>                                   |    77  |             end
# >>                                   |    78  |           end
# >>                                   |    79  |         end
# >>                                   |    80  | 
# >>                                   |    81  |         # 何かある
# >>     1    (0.1%)                   |    82  |         if ary = e.board_parser.other_objects_hash_ary["●"]
# >>                                   |    83  |           ary.each do |obj|
# >>                                   |    84  |             pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    85  |             if !player.board[pt]
# >>                                   |    86  |               throw :skip
# >>                                   |    87  |             end
# >>                                   |    88  |           end
# >>                                   |    89  |         end
# >>                                   |    90  | 
# >>                                   |    91  |         # 移動元ではない
# >>                                   |    92  |         if ary = e.board_parser.other_objects_hash_ary["☆"]
# >>                                   |    93  |           ary.each do |obj|
# >>                                   |    94  |             pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    95  |             before_soldier = player.runner.before_soldier
# >>                                   |    96  |             if before_soldier && pt == before_soldier.point
# >>                                   |    97  |               throw :skip
# >>                                   |    98  |             end
# >>                                   |    99  |           end
# >>                                   |   100  |         end
# >>                                   |   101  | 
# >>                                   |   102  |         # 移動元(any条件)
# >>                                   |   103  |         ary = e.board_parser.other_objects_hash_ary["★"]
# >>                                   |   104  |         if ary.present?
# >>                                   |   105  |           before_soldier = player.runner.before_soldier
# >>                                   |   106  |           if !before_soldier
# >>                                   |   107  |             # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   108  |             throw :skip
# >>                                   |   109  |           end
# >>     2    (0.2%)                   |   110  |           if ary.any? { |e|
# >>     1    (0.1%)                   |   111  |               pt = e[:point].reverse_if_white(player.location)
# >>     1    (0.1%)                   |   112  |               pt == before_soldier.point
# >>                                   |   113  |             }
# >>                                   |   114  |           else
# >>                                   |   115  |             throw :skip
# >>                                   |   116  |           end
# >>                                   |   117  |         end
# >>                                   |   118  | 
# >>                                   |   119  |         if e.not_have_pawn
# >>                                   |   120  |           if player.pieces.include?(Piece.fetch(:pawn))
# >>                                   |   121  |             throw :skip
# >>                                   |   122  |           end
# >>                                   |   123  |         end
# >>                                   |   124  | 
# >>                                   |   125  |         if e.not_have_anything_except_pawn
# >>                                   |   126  |           unless (player.pieces - [Piece.fetch(:pawn)]).empty?
# >>                                   |   127  |             throw :skip
# >>                                   |   128  |           end
# >>                                   |   129  |         end
# >>                                   |   130  | 
# >>     1    (0.1%)                   |   131  |         if v = e.hold_piece_eq
# >>     1    (0.1%)                   |   132  |           if player.pieces.sort != v.sort
# >>                                   |   133  |             throw :skip
# >>                                   |   134  |           end
# >>                                   |   135  |         end
# >>                                   |   136  | 
# >>                                   |   137  |         if v = e.hold_piece_in
# >>                                   |   138  |           unless v.all? {|x| player.pieces.include?(x) }
# >>                                   |   139  |             throw :skip
# >>                                   |   140  |           end
# >>                                   |   141  |         end
# >>                                   |   142  | 
# >>                                   |   143  |         if v = e.hold_piece_not_in
# >>                                   |   144  |           if v.any? {|x| player.pieces.include?(x) }
# >>                                   |   145  |             throw :skip
# >>                                   |   146  |           end
# >>                                   |   147  |         end
# >>                                   |   148  | 
# >>    49    (4.3%)                   |   149  |         soldiers = on_board_soldiers(e)
# >>                                   |   150  | 
# >>                                   |   151  |         # どれかが盤上に含まれる
# >>     3    (0.3%)                   |   152  |         if v = e.board_parser.any_exist_soldiers.presence
# >>     6    (0.5%) /     3   (0.3%)  |   153  |           if v.any? {|o| soldiers.include?(o) }
# >>                                   |   154  |           else
# >>                                   |   155  |             throw :skip
# >>                                   |   156  |           end
# >>                                   |   157  |         end
# >>                                   |   158  | 
# >>    69    (6.0%) /    21   (1.8%)  |   159  |         if e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
# >>                                   |   160  |           list << e
# >>     1    (0.1%)                   |   161  |           player.runner.skill_set.public_send(e.tactic_info.var_key) << e
# >>                                   |   162  |         end
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:     5 self (0.4%)  /    203 total (17.7%)
# >>   callers:
# >>      203  (  100.0%)  Bushido::Player#execute
# >>      130  (   64.0%)  Bushido::SkillMonitor#execute
# >>   callees (198 total):
# >>      130  (   65.7%)  Bushido::SkillMonitor#execute_one
# >>      130  (   65.7%)  Bushido::SkillMonitor#execute
# >>       59  (   29.8%)  Bushido::TacticInfo.soldier_hash_table
# >>        6  (    3.0%)  Bushido::SkillMonitor#current_soldier
# >>        3  (    1.5%)  Bushido::Point#hash
# >>   code:
# >>                                   |    11  |     def execute
# >>    73    (6.4%) /     5   (0.4%)  |    12  |       elements = TacticInfo.soldier_hash_table[current_soldier] || []
# >>   260   (22.6%)                   |    13  |       elements.each { |e| execute_one(e) }
# >>                                   |    14  |     end
# >> Bushido::Position::Base.lookup (/Users/ikeda/src/bushido/lib/bushido/position.rb:73)
# >>   samples:    92 self (8.0%)  /     93 total (8.1%)
# >>   callers:
# >>       51  (   54.8%)  Bushido::Position::Hpos.lookup
# >>       42  (   45.2%)  Bushido::Position::Vpos.lookup
# >>   callees (1 total):
# >>        1  (  100.0%)  Bushido::Position::Base.units_set
# >>   code:
# >>                                   |    73  |         def lookup(value)
# >>    59    (5.1%) /    59   (5.1%)  |    74  |           if value.kind_of?(Base)
# >>     3    (0.3%) /     3   (0.3%)  |    75  |             return value
# >>                                   |    76  |           end
# >>     9    (0.8%) /     9   (0.8%)  |    77  |           if value.kind_of?(String)
# >>     1    (0.1%)                   |    78  |             value = units_set[value]
# >>                                   |    79  |           end
# >>                                   |    80  |           if value
# >>    14    (1.2%) /    14   (1.2%)  |    81  |             @instance ||= {}
# >>     7    (0.6%) /     7   (0.6%)  |    82  |             @instance[value] ||= new(value).freeze
# >>                                   |    83  |           end
