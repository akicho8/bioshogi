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

# >> 4409.3 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 2519 (0.00% miss rate)
# >>   GC: 303 (12.03%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>       1723  (68.4%)         312  (12.4%)     Bushido::SkillMonitor#execute
# >>        307  (12.2%)         307  (12.2%)     block (4 levels) in memory_record
# >>        303  (12.0%)         303  (12.0%)     (garbage collection)
# >>        148   (5.9%)         147   (5.8%)     Bushido::Position::Base.lookup
# >>        118   (4.7%)         118   (4.7%)     Bushido::Point#to_xy
# >>        195   (7.7%)         116   (4.6%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>         79   (3.1%)          79   (3.1%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>        262  (10.4%)          77   (3.1%)     Bushido::Point.lookup
# >>        226   (9.0%)          74   (2.9%)     Bushido::SkillMonitor#cached_soldiers
# >>         62   (2.5%)          62   (2.5%)     Bushido::Battler#to_soldier
# >>         54   (2.1%)          54   (2.1%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>        137   (5.4%)          48   (1.9%)     Bushido::Soldier#reverse
# >>        135   (5.4%)          44   (1.7%)     Bushido::Board::ReaderMethods#lookup
# >>         55   (2.2%)          41   (1.6%)     Object#present?
# >>        131   (5.2%)          40   (1.6%)     Bushido::ShapeInfo#board_parser
# >>         38   (1.5%)          38   (1.5%)     Bushido::Position::Base.units
# >>         45   (1.8%)          37   (1.5%)     ActiveSupport::Inflector#apply_inflections
# >>         32   (1.3%)          32   (1.3%)     Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>         31   (1.2%)          31   (1.2%)     Bushido::Piece::VectorMethods#select_vectors2
# >>         31   (1.2%)          31   (1.2%)     Bushido::Point#initialize
# >>        131   (5.2%)          28   (1.1%)     Bushido::Point#eql?
# >>        101   (4.0%)          28   (1.1%)     Bushido::Position::Hpos.lookup
# >>         25   (1.0%)          20   (0.8%)     ActiveSupport::Inflector#camelize
# >>         95   (3.8%)          20   (0.8%)     Bushido::Position::Vpos.lookup
# >>         71   (2.8%)          19   (0.8%)     Bushido::Movabler#piece_store
# >>         16   (0.6%)          16   (0.6%)     Bushido::HandLog#initialize
# >>         16   (0.6%)          16   (0.6%)     Bushido::Player#board
# >>         14   (0.6%)          14   (0.6%)     NilClass#blank?
# >>         14   (0.6%)          14   (0.6%)     Hash#slice
# >>         18   (0.7%)          13   (0.5%)     ActiveSupport::Inflector#inflections
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:   312 self (12.4%)  /   1723 total (68.4%)
# >>   callers:
# >>     2159  (  125.3%)  Bushido::SkillMonitor#execute
# >>     1723  (  100.0%)  Bushido::Player#execute
# >>     1722  (   99.9%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      926  (   53.7%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      702  (   40.7%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>   callees (1411 total):
# >>     2159  (  153.0%)  Bushido::SkillMonitor#execute
# >>     1722  (  122.0%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      926  (   65.6%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      702  (   49.8%)  MemoryRecord::SingletonMethods::ClassMethods#each
# >>      232  (   16.4%)  Bushido::AttackInfo#board_parser
# >>      226  (   16.0%)  Bushido::SkillMonitor#cached_soldiers
# >>      190  (   13.5%)  Bushido::DefenseInfo#board_parser
# >>      122  (    8.6%)  Bushido::Point#==
# >>      119  (    8.4%)  Bushido::Point#reverse_if_white
# >>       95  (    6.7%)  block (4 levels) in memory_record
# >>       89  (    6.3%)  Bushido::Board::ReaderMethods#[]
# >>       87  (    6.2%)  Bushido::SkillGroupInfo#model
# >>       35  (    2.5%)  Bushido::Soldier#reverse
# >>       32  (    2.3%)  Bushido::BoardParser::FireBoardParser#other_objects_hash_ary
# >>       31  (    2.2%)  Object#present?
# >>       26  (    1.8%)  Object#presence
# >>       13  (    0.9%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>       11  (    0.8%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        9  (    0.6%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        8  (    0.6%)  Bushido::DefenseInfo::AttackInfoSharedMethods#gentei_match_any
# >>        8  (    0.6%)  Bushido::Player#board
# >>        8  (    0.6%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        8  (    0.6%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        7  (    0.5%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        6  (    0.4%)  Bushido::DefenseInfo::AttackInfoSharedMethods#triggers
# >>        6  (    0.4%)  Bushido::DefenseInfo::AttackInfoSharedMethods#gentei_match_any
# >>        6  (    0.4%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        6  (    0.4%)  Bushido::Runner#before_soldier
# >>        5  (    0.4%)  Bushido::Runner#current_soldier
# >>        4  (    0.3%)  Bushido::BoardParser::FireBoardParser#trigger_soldiers
# >>        4  (    0.3%)  Bushido::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        3  (    0.2%)  Bushido::Player::SkillMonitorMethods#skill_set
# >>        3  (    0.2%)  Bushido::BoardParser::Base#soldiers
# >>        2  (    0.1%)  Bushido::SkillGroupInfo#var_key
# >>        2  (    0.1%)  Bushido::ApplicationMemoryRecord#<=>
# >>        2  (    0.1%)  Bushido::SkillSet#defense_infos
# >>        2  (    0.1%)  Bushido::TurnInfo#senteban_or_goteban
# >>        2  (    0.1%)  Bushido::Piece.fetch
# >>        1  (    0.1%)  Bushido::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        1  (    0.1%)  Bushido::BoardParser::FireBoardParser#any_exist_soldiers
# >>   code:
# >>                                   |    11  |     def execute
# >>     1    (0.0%) /     1   (0.0%)  |    12  |       skip = Object.new
# >>  1722   (68.4%)                   |    13  |       SkillGroupInfo.each do |group|
# >>     7    (0.3%)                   |    14  |         list = player.skill_set.public_send(group.var_key)
# >>  1715   (68.1%)                   |    15  |         group.model.each do |e|
# >>                                   |    16  |           hit_flag = nil
# >>  1628   (64.6%) /    20   (0.8%)  |    17  |           catch skip do
# >>                                   |    18  |             # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>    37    (1.5%) /    37   (1.5%)  |    19  |             if list.include?(e)
# >>                                   |    20  |               throw skip
# >>                                   |    21  |             end
# >>                                   |    22  | 
# >>                                   |    23  |             # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>    22    (0.9%) /     8   (0.3%)  |    24  |             if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    25  |               throw skip
# >>                                   |    26  |             end
# >>                                   |    27  | 
# >>    25    (1.0%) /     1   (0.0%)  |    28  |             if e.turn_limit
# >>     2    (0.1%) /     1   (0.0%)  |    29  |               if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    30  |                 throw skip
# >>                                   |    31  |               end
# >>                                   |    32  |             end
# >>                                   |    33  | 
# >>     9    (0.4%) /     1   (0.0%)  |    34  |             if e.turn_eq
# >>     1    (0.0%)                   |    35  |               if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    36  |                 throw skip
# >>                                   |    37  |               end
# >>                                   |    38  |             end
# >>                                   |    39  | 
# >>    12    (0.5%)                   |    40  |             if e.teban_eq
# >>     3    (0.1%) /     1   (0.0%)  |    41  |               if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
# >>                                   |    42  |                 throw skip
# >>                                   |    43  |               end
# >>                                   |    44  |             end
# >>                                   |    45  | 
# >>     7    (0.3%) /     1   (0.0%)  |    46  |             if e.kaisenmae
# >>     4    (0.2%) /     4   (0.2%)  |    47  |               if player.mediator.kill_counter.positive?
# >>                                   |    48  |                 throw skip
# >>                                   |    49  |               end
# >>                                   |    50  |             end
# >>                                   |    51  | 
# >>     7    (0.3%)                   |    52  |             if e.stroke_only
# >>                                   |    53  |               if player.runner.before_soldier
# >>                                   |    54  |                 throw skip
# >>                                   |    55  |               end
# >>                                   |    56  |             end
# >>                                   |    57  | 
# >>     7    (0.3%) /     1   (0.0%)  |    58  |             if e.kill_only
# >>                                   |    59  |               unless player.runner.tottakoma
# >>                                   |    60  |                 throw skip
# >>                                   |    61  |               end
# >>                                   |    62  |             end
# >>                                   |    63  | 
# >>     6    (0.2%) /     2   (0.1%)  |    64  |             if v = e.hold_piece_count_eq
# >>                                   |    65  |               if player.pieces.size != v
# >>                                   |    66  |                 throw skip
# >>                                   |    67  |               end
# >>                                   |    68  |             end
# >>                                   |    69  | 
# >>                                   |    70  |             # 何もない
# >>   191    (7.6%) /     7   (0.3%)  |    71  |             if ary = e.board_parser.other_objects_hash_ary["○"]
# >>   190    (7.5%)                   |    72  |               ary.each do |obj|
# >>    92    (3.7%)                   |    73  |                 pt = obj[:point].reverse_if_white(player.location)
# >>    97    (3.9%)                   |    74  |                 if player.board[pt]
# >>     1    (0.0%) /     1   (0.0%)  |    75  |                   throw skip
# >>                                   |    76  |                 end
# >>                                   |    77  |               end
# >>                                   |    78  |             end
# >>                                   |    79  | 
# >>                                   |    80  |             # 何かある
# >>    57    (2.3%) /     2   (0.1%)  |    81  |             if ary = e.board_parser.other_objects_hash_ary["●"]
# >>                                   |    82  |               ary.each do |obj|
# >>                                   |    83  |                 pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    84  |                 if !player.board[pt]
# >>                                   |    85  |                   throw skip
# >>                                   |    86  |                 end
# >>                                   |    87  |               end
# >>                                   |    88  |             end
# >>                                   |    89  | 
# >>                                   |    90  |             # 移動元ではない
# >>    59    (2.3%) /     4   (0.2%)  |    91  |             if ary = e.board_parser.other_objects_hash_ary["☆"]
# >>                                   |    92  |               ary.each do |obj|
# >>                                   |    93  |                 pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    94  |                 before_soldier = player.runner.before_soldier
# >>                                   |    95  |                 if before_soldier && pt == before_soldier.point
# >>                                   |    96  |                   throw skip
# >>                                   |    97  |                 end
# >>                                   |    98  |               end
# >>                                   |    99  |             end
# >>                                   |   100  | 
# >>                                   |   101  |             # e.board_parser.other_objects.each do |obj|
# >>                                   |   102  |             #   # 何もない
# >>                                   |   103  |             #   if obj[:something] == "○"
# >>                                   |   104  |             #     pt = obj[:point].reverse_if_white(player.location)
# >>                                   |   105  |             #     if player.board[pt]
# >>                                   |   106  |             #       throw skip
# >>                                   |   107  |             #     end
# >>                                   |   108  |             #   end
# >>                                   |   109  |             #
# >>                                   |   110  |             #   # 何かある
# >>                                   |   111  |             #   if obj[:something] == "●"
# >>                                   |   112  |             #     pt = obj[:point].reverse_if_white(player.location)
# >>                                   |   113  |             #     if !player.board[pt]
# >>                                   |   114  |             #       throw skip
# >>                                   |   115  |             #     end
# >>                                   |   116  |             #   end
# >>                                   |   117  |             #
# >>                                   |   118  |             #   # 移動元ではない
# >>                                   |   119  |             #   if obj[:something] == "☆"
# >>                                   |   120  |             #     pt = obj[:point].reverse_if_white(player.location)
# >>                                   |   121  |             #     before_soldier = player.runner.before_soldier
# >>                                   |   122  |             #     if before_soldier && pt == before_soldier.point
# >>                                   |   123  |             #       throw skip
# >>                                   |   124  |             #     end
# >>                                   |   125  |             #   end
# >>                                   |   126  |             # end
# >>                                   |   127  | 
# >>                                   |   128  |             # 移動元(any条件)
# >>    58    (2.3%)                   |   129  |             ary = e.board_parser.other_objects_hash_ary["★"]
# >>    31    (1.2%)                   |   130  |             if ary.present?
# >>     6    (0.2%)                   |   131  |               before_soldier = player.runner.before_soldier
# >>                                   |   132  |               if !before_soldier
# >>                                   |   133  |                 # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   134  |                 throw skip
# >>                                   |   135  |               end
# >>    36    (1.4%)                   |   136  |               if ary.any? { |e|
# >>    27    (1.1%)                   |   137  |                   pt = e[:point].reverse_if_white(player.location)
# >>     9    (0.4%)                   |   138  |                   pt == before_soldier.point
# >>                                   |   139  |                 }
# >>                                   |   140  |               else
# >>                                   |   141  |                 throw skip
# >>                                   |   142  |               end
# >>                                   |   143  |             end
# >>                                   |   144  | 
# >>     9    (0.4%) /     1   (0.0%)  |   145  |             if e.fuganai
# >>     2    (0.1%)                   |   146  |               if player.pieces.include?(Piece.fetch(:pawn))
# >>                                   |   147  |                 throw skip
# >>                                   |   148  |               end
# >>                                   |   149  |             end
# >>                                   |   150  | 
# >>     6    (0.2%) /     1   (0.0%)  |   151  |             if e.fu_igai_mottetara_dame
# >>                                   |   152  |               unless (player.pieces - [Piece.fetch(:pawn)]).empty?
# >>                                   |   153  |                 throw skip
# >>                                   |   154  |               end
# >>                                   |   155  |             end
# >>                                   |   156  | 
# >>    20    (0.8%)                   |   157  |             if v = e.hold_piece_eq
# >>     3    (0.1%) /     1   (0.0%)  |   158  |               if player.pieces.sort != v.sort
# >>                                   |   159  |                 throw skip
# >>                                   |   160  |               end
# >>                                   |   161  |             end
# >>                                   |   162  | 
# >>    12    (0.5%)                   |   163  |             if v = e.hold_piece_in
# >>     2    (0.1%) /     1   (0.0%)  |   164  |               unless v.all? {|x| player.pieces.include?(x) }
# >>                                   |   165  |                 throw skip
# >>                                   |   166  |               end
# >>                                   |   167  |             end
# >>                                   |   168  | 
# >>    14    (0.6%)                   |   169  |             if v = e.hold_piece_not_in
# >>                                   |   170  |               if v.any? {|x| player.pieces.include?(x) }
# >>                                   |   171  |                 throw skip
# >>                                   |   172  |               end
# >>                                   |   173  |             end
# >>                                   |   174  | 
# >>    15    (0.6%)                   |   175  |             if v = e.triggers
# >>                                   |   176  |               current_soldier = player.runner.current_soldier
# >>                                   |   177  |               if player.location.key == :white
# >>                                   |   178  |                 current_soldier = current_soldier.reverse
# >>                                   |   179  |               end
# >>                                   |   180  |               v.each do |soldier|
# >>                                   |   181  |                 if current_soldier != soldier
# >>                                   |   182  |                   throw skip
# >>                                   |   183  |                 end
# >>                                   |   184  |               end
# >>                                   |   185  |             end
# >>                                   |   186  | 
# >>                                   |   187  |             # ここは位置のハッシュを作っておくのがいいかもしれん
# >>    54    (2.1%)                   |   188  |             if v = e.board_parser.trigger_soldiers.presence
# >>     5    (0.2%)                   |   189  |               current_soldier = player.runner.current_soldier
# >>     2    (0.1%)                   |   190  |               if player.location.key == :white
# >>    35    (1.4%)                   |   191  |                 current_soldier = current_soldier.reverse
# >>                                   |   192  |               end
# >>    15    (0.6%)                   |   193  |               v.each do |soldier|
# >>    15    (0.6%) /    13   (0.5%)  |   194  |                 if current_soldier != soldier
# >>                                   |   195  |                   throw skip
# >>                                   |   196  |                 end
# >>                                   |   197  |               end
# >>                                   |   198  |             end
# >>                                   |   199  | 
# >>   226    (9.0%)                   |   200  |             soldiers = cached_soldiers(e)
# >>                                   |   201  | 
# >>                                   |   202  |             # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
# >>    14    (0.6%)                   |   203  |             if v = e.gentei_match_any
# >>                                   |   204  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   205  |               else
# >>                                   |   206  |                 throw skip
# >>                                   |   207  |               end
# >>                                   |   208  |             end
# >>                                   |   209  | 
# >>                                   |   210  |             # どれかが盤上に含まれる
# >>    39    (1.5%) /     1   (0.0%)  |   211  |             if v = e.board_parser.any_exist_soldiers.presence
# >>                                   |   212  |               if v.any? {|o| soldiers.include?(o) }
# >>                                   |   213  |               else
# >>                                   |   214  |                 throw skip
# >>                                   |   215  |               end
# >>                                   |   216  |             end
# >>                                   |   217  | 
# >>     6    (0.2%) /     1   (0.0%)  |   218  |             if e.compare_condition == :equal
# >>                                   |   219  |               hit_flag = (soldiers.sort == e.sorted_soldiers)
# >>    11    (0.4%) /     5   (0.2%)  |   220  |             elsif e.compare_condition == :include
# >>   658   (26.1%) /   196   (7.8%)  |   221  |               hit_flag = e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
# >>                                   |   222  |             else
