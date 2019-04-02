require "./example_helper"

# Bioshogi.config[:skill_monitor_enable] = false

require "stackprof"

ms = Benchmark.ms do
  StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
    # StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
    # StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do
    20.times do
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
# system "stackprof stackprof.dump --method Bioshogi::Place.lookup"

# system "stackprof stackprof.dump --method Bioshogi::PlayerExecutorHuman#hand_log"
# system "stackprof stackprof.dump --method Bioshogi::InputAdapter::Ki2Adapter#candidate_soldiers_select"
system "stackprof stackprof.dump --method Bioshogi::SkillMonitor#execute"
# system "stackprof stackprof.dump --method Bioshogi::Dimension::Base.lookup"
# system "stackprof stackprof.dump --method Hash#transform_keys"
# system "stackprof stackprof.dump --method Bioshogi::Soldier#attributes"

# system "stackprof stackprof.dump --method Bioshogi::Place.fetch"
# system "stackprof stackprof.dump --method Bioshogi::Movabler#move_list"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 7068.5 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 5338 (0.00% miss rate)
# >>   GC: 541 (10.13%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        541  (10.1%)         541  (10.1%)     (garbage collection)
# >>        473   (8.9%)         473   (8.9%)     block (3 levels) in memory_record
# >>        412   (7.7%)         390   (7.3%)     Bioshogi::Dimension::Base.lookup
# >>        268   (5.0%)         268   (5.0%)     Bioshogi::SimpleModel#initialize
# >>        222   (4.2%)         222   (4.2%)     Bioshogi::Dimension::Base#hash
# >>        166   (3.1%)         166   (3.1%)     Bioshogi::SimpleModel#initialize
# >>        842  (15.8%)         156   (2.9%)     Bioshogi::Place.lookup
# >>        135   (2.5%)         135   (2.5%)     Bioshogi::Place#to_xy
# >>        135   (2.5%)         127   (2.4%)     Bioshogi::InputParser#scan
# >>        125   (2.3%)         125   (2.3%)     Hash#symbolize_keys
# >>        110   (2.1%)         105   (2.0%)     Bioshogi::PieceVector#all_vectors
# >>        168   (3.1%)          87   (1.6%)     Bioshogi::Place#hash
# >>         80   (1.5%)          80   (1.5%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>       1202  (22.5%)          77   (1.4%)     Bioshogi::Movabler#move_list
# >>         68   (1.3%)          68   (1.3%)     ActiveSupport::Duration#initialize
# >>       1553  (29.1%)          65   (1.2%)     Bioshogi::Player#candidate_soldiers
# >>        193   (3.6%)          62   (1.2%)     #<Module:0x00007fdb3126f688>#<=>
# >>         53   (1.0%)          53   (1.0%)     Bioshogi::Dimension::Base.value_range
# >>         53   (1.0%)          53   (1.0%)     Bioshogi::Parser::Base::ConverterMethods#mb_ljust
# >>         50   (0.9%)          50   (0.9%)     Bioshogi::Dimension::Base.units
# >>         47   (0.9%)          47   (0.9%)     Bioshogi::SimpleModel#initialize
# >>        211   (4.0%)          44   (0.8%)     Bioshogi::Player::SoldierMethods#soldiers
# >>         43   (0.8%)          43   (0.8%)     #<Module:0x00007fdb312dda20>.kconv
# >>         43   (0.8%)          43   (0.8%)     Bioshogi::Soldier#attributes
# >>         94   (1.8%)          41   (0.8%)     Bioshogi::Dimension::Base#valid?
# >>         40   (0.7%)          40   (0.7%)     Bioshogi::Piece::VectorMethods#piece_vector
# >>         49   (0.9%)          39   (0.7%)     Bioshogi::Dimension::Yplace#number_format
# >>         68   (1.3%)          39   (0.7%)     Bioshogi::Board::UpdateMethods#place_on
# >>         38   (0.7%)          38   (0.7%)     Bioshogi::HandLog#hand
# >>         36   (0.7%)          36   (0.7%)     Bioshogi::Dimension::Yplace._units
# >> Bioshogi::SkillMonitor#execute_one (/Users/ikeda/src/bioshogi/lib/bioshogi/skill_monitor.rb:56)
# >>   samples:    26 self (0.5%)  /    400 total (7.5%)
# >>   callers:
# >>      400  (  100.0%)  Bioshogi::SkillMonitor#execute
# >>      294  (   73.5%)  Bioshogi::SkillMonitor#execute_block
# >>       68  (   17.0%)  Bioshogi::SkillMonitor#execute_one
# >>   callees (374 total):
# >>      399  (  106.7%)  Bioshogi::SkillMonitor#execute_block
# >>       68  (   18.2%)  Bioshogi::SkillMonitor#execute_one
# >>       50  (   13.4%)  Bioshogi::SkillMonitor#soldier_exist?
# >>       39  (   10.4%)  Bioshogi::DefenseInfo#board_parser
# >>       32  (    8.6%)  block (3 levels) in memory_record
# >>       22  (    5.9%)  Bioshogi::SkillMonitor#cold_war_verification
# >>       22  (    5.9%)  Bioshogi::AttackInfo#board_parser
# >>       16  (    4.3%)  #<Module:0x00007fdb31347088>#<=>
# >>       10  (    2.7%)  Bioshogi::SkillMonitor#location
# >>        9  (    2.4%)  Bioshogi::Place#hash
# >>        7  (    1.9%)  Bioshogi::SoldierBox#location_adjust
# >>        7  (    1.9%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        7  (    1.9%)  Bioshogi::BoardParser::Base#location_adjust
# >>        6  (    1.6%)  Bioshogi::BoardParser::FireBoardParser#other_objects_loc_ary
# >>        5  (    1.3%)  #<Module:0x00007fdb31325d48>#<=>
# >>        5  (    1.3%)  Bioshogi::SkillMonitor#surface
# >>        4  (    1.1%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#cached_descendants
# >>        4  (    1.1%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        3  (    0.8%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        3  (    0.8%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        2  (    0.5%)  Object#presence
# >>        2  (    0.5%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        2  (    0.5%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#skip_elements
# >>        2  (    0.5%)  #<Module:0x00007fdb32095230>#<=>
# >>        2  (    0.5%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#skip_elements
# >>        2  (    0.5%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#hold_piece_in
# >>        2  (    0.5%)  Delegator#!=
# >>        1  (    0.3%)  Bioshogi::BoardParser::FireBoardParser#other_objects_loc_places_hash
# >>        1  (    0.3%)  Bioshogi::NoteInfo#board_parser
# >>        1  (    0.3%)  Bioshogi::TurnInfo#order_key
# >>        1  (    0.3%)  Bioshogi::SkillMonitor#origin_soldier
# >>   code:
# >>                                   |    56  |     def execute_one(e)
# >>   399    (7.5%)                   |    57  |       execute_block(e) do |list|
# >>                                   |    58  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>    27    (0.5%) /     8   (0.1%)  |    59  |         if list.include?(e)
# >>                                   |    60  |           throw :skip
# >>                                   |    61  |         end
# >>                                   |    62  | 
# >>                                   |    63  |         # 「居飛車」判定のとき「振り飛車」がすでにあればスキップ
# >>     4    (0.1%)                   |    64  |         if e.skip_elements
# >>                                   |    65  |           if e.skip_elements.any? { |e| list.include?(e) }
# >>                                   |    66  |             throw :skip
# >>                                   |    67  |           end
# >>                                   |    68  |         end
# >>                                   |    69  | 
# >>                                   |    70  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>    21    (0.4%) /     1   (0.0%)  |    71  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    72  |           throw :skip
# >>                                   |    73  |         end
# >>                                   |    74  | 
# >>                                   |    75  |         # 手数制限。制限を超えていたらskip
# >>     5    (0.1%) /     1   (0.0%)  |    76  |         if e.turn_limit
# >>                                   |    77  |           if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    78  |             throw :skip
# >>                                   |    79  |           end
# >>                                   |    80  |         end
# >>                                   |    81  | 
# >>                                   |    82  |         # 手数限定。手数が異なっていたらskip
# >>     6    (0.1%)                   |    83  |         if e.turn_eq
# >>                                   |    84  |           if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    85  |             throw :skip
# >>                                   |    86  |           end
# >>                                   |    87  |         end
# >>                                   |    88  | 
# >>                                   |    89  |         # 手番限定。手番が異なればskip
# >>     3    (0.1%) /     1   (0.0%)  |    90  |         if e.order_key
# >>     1    (0.0%)                   |    91  |           if e.order_key != player.mediator.turn_info.order_key
# >>                                   |    92  |             throw :skip
# >>                                   |    93  |           end
# >>                                   |    94  |         end
# >>                                   |    95  | 
# >>                                   |    96  |         # 開戦済みならskip
# >>    22    (0.4%)                   |    97  |         cold_war_verification(e)
# >>                                   |    98  | 
# >>                                   |    99  |         # 「打」時制限。移動元駒があればskip
# >>     1    (0.0%)                   |   100  |         if e.drop_only
# >>                                   |   101  |           if origin_soldier
# >>                                   |   102  |             throw :skip
# >>                                   |   103  |           end
# >>                                   |   104  |         end
# >>                                   |   105  | 
# >>                                   |   106  |         # 駒を取ったとき制限。取ってないならskip
# >>     2    (0.0%)                   |   107  |         if e.kill_only
# >>                                   |   108  |           unless executor.captured_soldier
# >>                                   |   109  |             throw :skip
# >>                                   |   110  |           end
# >>                                   |   111  |         end
# >>                                   |   112  | 
# >>                                   |   113  |         # 所持駒数一致制限。異なっていたらskip
# >>     3    (0.1%) /     1   (0.0%)  |   114  |         if v = e.hold_piece_empty
# >>                                   |   115  |           if !player.piece_box.empty?
# >>                                   |   116  |             throw :skip
# >>                                   |   117  |           end
# >>                                   |   118  |         end
# >>                                   |   119  | 
# >>                                   |   120  |         if true
# >>                                   |   121  |           # 何もない制限。何かあればskip
# >>    28    (0.5%) /     2   (0.0%)  |   122  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["○"]
# >>    13    (0.2%)                   |   123  |             ary.each do |e|
# >>    13    (0.2%)                   |   124  |               if surface[e[:place]]
# >>                                   |   125  |                 throw :skip
# >>                                   |   126  |               end
# >>                                   |   127  |             end
# >>                                   |   128  |           end
# >>                                   |   129  | 
# >>                                   |   130  |           # 何かある制限。何もなければskip
# >>    14    (0.3%) /     3   (0.1%)  |   131  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["●"]
# >>                                   |   132  |             ary.each do |e|
# >>                                   |   133  |               if !surface[e[:place]]
# >>                                   |   134  |                 throw :skip
# >>                                   |   135  |               end
# >>                                   |   136  |             end
# >>                                   |   137  |           end
# >>                                   |   138  |         end
# >>                                   |   139  | 
# >>                                   |   140  |         if true
# >>                                   |   141  |           # 移動元ではない制限。移動元だったらskip
# >>    16    (0.3%) /     1   (0.0%)  |   142  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["☆"]
# >>                                   |   143  |             # 移動元についての指定があるのに移動元がない場合はそもそも状況が異なるのでskip
# >>                                   |   144  |             unless origin_soldier
# >>                                   |   145  |               throw :skip
# >>                                   |   146  |             end
# >>                                   |   147  |             ary.each do |e|
# >>                                   |   148  |               if e[:place] == origin_soldier.place
# >>                                   |   149  |                 throw :skip
# >>                                   |   150  |               end
# >>                                   |   151  |             end
# >>                                   |   152  |           end
# >>                                   |   153  | 
# >>                                   |   154  |           # 移動元である(any条件)。どの移動元にも該当しなかったらskip
# >>    18    (0.3%) /     5   (0.1%)  |   155  |           if places_hash = e.board_parser.other_objects_loc_places_hash[location.key]["★"]
# >>                                   |   156  |             # 移動元がないということは、もう何も該当しないので skip
# >>     1    (0.0%)                   |   157  |             unless origin_soldier
# >>                                   |   158  |               throw :skip
# >>                                   |   159  |             end
# >>     1    (0.0%)                   |   160  |             if places_hash[origin_soldier.place]
# >>                                   |   161  |               # 移動元があったのでOK
# >>                                   |   162  |             else
# >>                                   |   163  |               throw :skip
# >>                                   |   164  |             end
# >>                                   |   165  |           end
# >>                                   |   166  |         end
# >>                                   |   167  | 
# >>                                   |   168  |         # 自分の金or銀がある
# >>     7    (0.1%) /     1   (0.0%)  |   169  |         if ary = e.board_parser.other_objects_loc_ary[location.key]["◆"]
# >>                                   |   170  |           ary.each do |e|
# >>                                   |   171  |             unless worth_more_gteq_silver?(e[:place])
# >>                                   |   172  |               throw :skip
# >>                                   |   173  |             end
# >>                                   |   174  |           end
# >>                                   |   175  |         end
# >>                                   |   176  | 
# >>                                   |   177  |         # 自分の歩以上の駒がある
# >>     5    (0.1%)                   |   178  |         if ary = e.board_parser.other_objects_loc_ary[location.key]["◇"]
# >>                                   |   179  |           ary.each do |e|
# >>                                   |   180  |             unless worth_more_gteq_pawn?(e[:place])
# >>                                   |   181  |               throw :skip
# >>                                   |   182  |             end
# >>                                   |   183  |           end
# >>                                   |   184  |         end
# >>                                   |   185  | 
# >>                                   |   186  |         # 歩を持っていたらskip
# >>     1    (0.0%)                   |   187  |         if e.not_have_pawn
# >>                                   |   188  |           if piece_box.has_key?(:pawn)
# >>                                   |   189  |             throw :skip
# >>                                   |   190  |           end
# >>                                   |   191  |         end
# >>                                   |   192  | 
# >>                                   |   193  |         # # 歩を除いて何か持っていたらskip
# >>                                   |   194  |         # if e.not_have_anything_except_pawn
# >>                                   |   195  |         #   if !piece_box.except(:pawn).empty?
# >>                                   |   196  |         #     throw :skip
# >>                                   |   197  |         #   end
# >>                                   |   198  |         # end
# >>                                   |   199  | 
# >>                                   |   200  |         if true
# >>                                   |   201  |           # 駒が一致していなければskip
# >>     6    (0.1%)                   |   202  |           if v = e.hold_piece_eq
# >>     2    (0.0%)                   |   203  |             if piece_box != v
# >>                                   |   204  |               throw :skip
# >>                                   |   205  |             end
# >>                                   |   206  |           end
# >>                                   |   207  | 
# >>                                   |   208  |           # 指定の駒をすべて含んでいるならOK
# >>     4    (0.1%)                   |   209  |           if v = e.hold_piece_in
# >>                                   |   210  |             if v.all? { |piece_key, _| piece_box.has_key?(piece_key) }
# >>                                   |   211  |             else
# >>                                   |   212  |               throw :skip
# >>                                   |   213  |             end
# >>                                   |   214  |           end
# >>                                   |   215  | 
# >>                                   |   216  |           # 指定の駒をどれか含んでいるならskip
# >>     4    (0.1%)                   |   217  |           if v = e.hold_piece_not_in
# >>                                   |   218  |             if v.any? { |piece_key, _| piece_box.has_key?(piece_key) }
# >>                                   |   219  |               throw :skip
# >>                                   |   220  |             end
# >>                                   |   221  |           end
# >>                                   |   222  |         end
# >>                                   |   223  | 
# >>                                   |   224  |         # どれかが盤上に正確に含まれるならOK
# >>    21    (0.4%)                   |   225  |         if ary = e.board_parser.any_exist_soldiers.location_adjust[location.key].presence
# >>     6    (0.1%)                   |   226  |           if ary.any? { |e| soldier_exist?(e) }
# >>                                   |   227  |           else
# >>                                   |   228  |             throw :skip
# >>                                   |   229  |           end
# >>                                   |   230  |         end
# >>                                   |   231  | 
# >>                                   |   232  |         # 指定の配置が盤上に含まれるならOK
# >>    12    (0.2%)                   |   233  |         ary = e.board_parser.location_adjust[location.key]
# >>    95    (1.8%) /     1   (0.0%)  |   234  |         if ary.all? { |e| soldier_exist?(e) }
# >>                                   |   235  |         else
# >>                                   |   236  |           throw :skip
# >>                                   |   237  |         end
# >>                                   |   238  |       end
# >>     1    (0.0%) /     1   (0.0%)  |   239  |     end
# >>                                   |   240  | 
# >> Bioshogi::SkillMonitor#execute (/Users/ikeda/src/bioshogi/lib/bioshogi/skill_monitor.rb:13)
# >>   samples:    14 self (0.3%)  /    747 total (14.0%)
# >>   callers:
# >>      747  (  100.0%)  Bioshogi::PlayerExecutorHuman#perform_skill_monitor
# >>      460  (   61.6%)  Bioshogi::SkillMonitor#execute
# >>       30  (    4.0%)  Bioshogi::SkillMonitor#execute_block
# >>   callees (733 total):
# >>      460  (   62.8%)  Bioshogi::SkillMonitor#execute
# >>      400  (   54.6%)  Bioshogi::SkillMonitor#execute_one
# >>      162  (   22.1%)  Bioshogi::TacticInfo.soldier_hash_table
# >>       46  (    6.3%)  Bioshogi::SkillMonitor#soldier
# >>       43  (    5.9%)  Bioshogi::SkillMonitor#execute_block
# >>       41  (    5.6%)  Bioshogi::Soldier#hash
# >>       14  (    1.9%)  Bioshogi::SkillMonitor#walk_counts
# >>       13  (    1.8%)  block (3 levels) in memory_record
# >>       10  (    1.4%)  Bioshogi::Soldier#eql?
# >>        6  (    0.8%)  block in <class:TechniqueMatcherInfo>
# >>        6  (    0.8%)  Bioshogi::TacticInfo.piece_hash_table
# >>        6  (    0.8%)  block in <class:TechniqueMatcherInfo>
# >>        5  (    0.7%)  Bioshogi::PlayerExecutorBase#mediator
# >>        5  (    0.7%)  block in <class:TechniqueMatcherInfo>
# >>        3  (    0.4%)  block in <class:TechniqueMatcherInfo>
# >>        1  (    0.1%)  Bioshogi::SkillMonitor#cold_war_verification
# >>        1  (    0.1%)  block in <class:TechniqueMatcherInfo>
# >>        1  (    0.1%)  block in <class:TechniqueMatcherInfo>
# >>   code:
# >>                                   |    13  |     def execute
# >>   256    (4.8%)                   |    14  |       if e = TacticInfo.soldier_hash_table[soldier]
# >>   417    (7.8%)                   |    15  |         e.each do |e|
# >>    17    (0.3%)                   |    16  |           walk_counts[e.key] += 1
# >>   400    (7.5%)                   |    17  |           execute_one(e)
# >>                                   |    18  |         end
# >>                                   |    19  |       end
# >>                                   |    20  | 
# >>     5    (0.1%)                   |    21  |       if executor.mediator.params[:skill_monitor_technique_enable]
# >>                                   |    22  |         # 主に手筋用で戦型チェックにも使える
# >>     6    (0.1%)                   |    23  |         key = [soldier.piece.key, soldier.promoted, !!executor.drop_hand]
# >>    19    (0.4%) /    13   (0.2%)  |    24  |         if e = TacticInfo.piece_hash_table[key]
# >>    43    (0.8%)                   |    25  |           e.each do |e|
# >>    43    (0.8%)                   |    26  |             execute_block(e) do |list|
# >>     6    (0.1%)                   |    27  |               walk_counts[e.key] += 1
# >>     1    (0.0%)                   |    28  |               cold_war_verification(e)
# >>    23    (0.4%)                   |    29  |               instance_eval(&e.technique_matcher_info.verify_process)
# >>                                   |    30  |             end
# >>                                   |    31  |           end
# >>                                   |    32  |         end
# >>                                   |    33  |       end
# >>                                   |    34  | 
# >>                                   |    35  |       # これはループなので遅い
# >>                                   |    36  |       # TacticInfo.piece_hash_table.each do |e|
# >>                                   |    37  |       #   execute_block(e) do |list|
# >>                                   |    38  |       #     cold_war_verification(e)
# >>                                   |    39  |       #     instance_eval(&e.technique_matcher_info.verify_process)
# >>                                   |    40  |       #   end
# >>                                   |    41  |       # end
# >>                                   |    42  | 
# >>     1    (0.0%) /     1   (0.0%)  |    43  |     end
# >>                                   |    44  | 
# >> Bioshogi::SkillMonitor#execute_block (/Users/ikeda/src/bioshogi/lib/bioshogi/skill_monitor.rb:47)
# >>   samples:    12 self (0.2%)  /    442 total (8.3%)
# >>   callers:
# >>      430  (   97.3%)  Bioshogi::SkillMonitor#execute_block
# >>      399  (   90.3%)  Bioshogi::SkillMonitor#execute_one
# >>       43  (    9.7%)  Bioshogi::SkillMonitor#execute
# >>   callees (430 total):
# >>      430  (  100.0%)  Bioshogi::SkillMonitor#execute_block
# >>      294  (   68.4%)  Bioshogi::SkillMonitor#execute_one
# >>       85  (   19.8%)  Bioshogi::SkillSet#list_of
# >>       30  (    7.0%)  Bioshogi::SkillMonitor#execute
# >>       14  (    3.3%)  Bioshogi::SkillMonitor#player
# >>        5  (    1.2%)  Bioshogi::Player::SkillMonitorMethods#skill_set
# >>        2  (    0.5%)  Bioshogi::SkillSet#list_push
# >>   code:
# >>                                   |    47  |     def execute_block(e)
# >>   430    (8.1%)                   |    48  |       catch :skip do
# >>   104    (1.9%)                   |    49  |         list = player.skill_set.list_of(e)
# >>   324    (6.1%)                   |    50  |         yield list
# >>                                   |    51  |         player.skill_set.list_push(e) # プレイヤーの個別設定
# >>     2    (0.0%)                   |    52  |         executor.skill_set.list_push(e) # executor の方にも設定(これいる？)
# >>                                   |    53  |       end
# >>    12    (0.2%) /    12   (0.2%)  |    54  |     end
# >>                                   |    55  | 
