require "./setup"

# Bioshogi.config[:skill_monitor_enable] = false

require "stackprof"

# StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
# StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do

ms = Benchmark.ms do
  StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
    20.times do
      ["csa", "ki2", "kif", "sfen"].each do |e|
        info = Parser.file_parse("katomomo.#{e}")
        # info.to_ki2
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

# system "stackprof stackprof.dump --method Bioshogi::PlayerExecutor::Human#hand_log"
# system "stackprof stackprof.dump --method Bioshogi::InputAdapter::Ki2Adapter#candidate_soldiers_select"
system "stackprof stackprof.dump --method Bioshogi::SkillMonitor#execute"
# system "stackprof stackprof.dump --method Bioshogi::Dimension::Base.lookup"
# system "stackprof stackprof.dump --method Hash#transform_keys"
# system "stackprof stackprof.dump --method Bioshogi::Soldier#attributes"

# system "stackprof stackprof.dump --method Bioshogi::Place.fetch"
# system "stackprof stackprof.dump --method Bioshogi::Movabler#move_list"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 3751.5 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 920 (0.00% miss rate)
# >>   GC: 139 (15.11%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        139  (15.1%)         139  (15.1%)     (garbage collection)
# >>        100  (10.9%)          97  (10.5%)     Bioshogi::Dimension::Base.lookup
# >>         91   (9.9%)          64   (7.0%)     Bioshogi::Parser#file_parse
# >>         46   (5.0%)          46   (5.0%)     block (3 levels) in memory_record
# >>         36   (3.9%)          36   (3.9%)     Bioshogi::SimpleModel#initialize
# >>         28   (3.0%)          28   (3.0%)     Hash#symbolize_keys
# >>         27   (2.9%)          25   (2.7%)     Bioshogi::InputParser#scan
# >>        144  (15.7%)          20   (2.2%)     Bioshogi::Place.lookup
# >>         19   (2.1%)          19   (2.1%)     Bioshogi::SimpleModel#initialize
# >>         18   (2.0%)          18   (2.0%)     Bioshogi::Place#to_xy
# >>         16   (1.7%)          16   (1.7%)     Bioshogi::Dimension::Base#hash
# >>         27   (2.9%)          13   (1.4%)     Bioshogi::Place#hash
# >>         13   (1.4%)          13   (1.4%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         15   (1.6%)          12   (1.3%)     Bioshogi::Dimension::PlaceX#number_hankaku
# >>         12   (1.3%)          11   (1.2%)     Bioshogi::Dimension::PlaceY#number_hankaku
# >>          9   (1.0%)           9   (1.0%)     Bioshogi::Soldier#attributes
# >>          9   (1.0%)           9   (1.0%)     ActiveSupport::Duration#initialize
# >>         14   (1.5%)           9   (1.0%)     ActiveSupport::Duration.===
# >>          8   (0.9%)           8   (0.9%)     Bioshogi::Parser::Base::ConverterMethods#mb_ljust
# >>          8   (0.9%)           8   (0.9%)     Bioshogi::SimpleModel#initialize
# >>          7   (0.8%)           7   (0.8%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         80   (8.7%)           7   (0.8%)     Bioshogi::BoardParser::KakinokiBoardParser#cell_walker
# >>          9   (1.0%)           7   (0.8%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>          7   (0.8%)           7   (0.8%)     #<Module:0x00007ff34a988e70>.kconv
# >>          7   (0.8%)           7   (0.8%)     Bioshogi::SkillSet#defense_infos
# >>          8   (0.9%)           6   (0.7%)     Bioshogi::SkillMonitor#surface
# >>         46   (5.0%)           6   (0.7%)     Bioshogi::PlayerExecutor::Base#input
# >>          9   (1.0%)           6   (0.7%)     Bioshogi::InputParser#match!
# >>         12   (1.3%)           6   (0.7%)     Bioshogi::Player::SoldierMethods#soldiers
# >>          9   (1.0%)           6   (0.7%)     #<Module:0x00007ff34a8f9540>#<=>
# >> Bioshogi::SkillMonitor#execute_block (/Users/ikeda/src/bioshogi/lib/bioshogi/skill_monitor.rb:47)
# >>   samples:     2 self (0.2%)  /     83 total (9.0%)
# >>   callers:
# >>       81  (   97.6%)  Bioshogi::SkillMonitor#execute_block
# >>       74  (   89.2%)  Bioshogi::SkillMonitor#execute_one
# >>        9  (   10.8%)  Bioshogi::SkillMonitor#execute
# >>   callees (81 total):
# >>       81  (  100.0%)  Bioshogi::SkillMonitor#execute_block
# >>       58  (   71.6%)  Bioshogi::SkillMonitor#execute_one
# >>       13  (   16.0%)  Bioshogi::SkillSet#list_of
# >>        7  (    8.6%)  Bioshogi::SkillMonitor#execute
# >>        3  (    3.7%)  Bioshogi::SkillMonitor#player
# >>   code:
# >>                                   |    47  |     def execute_block(e)
# >>    81    (8.8%)                   |    48  |       catch :skip do
# >>    16    (1.7%)                   |    49  |         list = player.skill_set.list_of(e)
# >>    65    (7.1%)                   |    50  |         yield list
# >>                                   |    51  |         player.skill_set.list_push(e) # プレイヤーの個別設定
# >>                                   |    52  |         executor.skill_set.list_push(e) # executor の方にも設定(これいる？)
# >>                                   |    53  |       end
# >>     2    (0.2%) /     2   (0.2%)  |    54  |     end
# >>                                   |    55  | 
# >> Bioshogi::SkillMonitor#execute_one (/Users/ikeda/src/bioshogi/lib/bioshogi/skill_monitor.rb:56)
# >>   samples:     1 self (0.1%)  /     74 total (8.0%)
# >>   callers:
# >>       74  (  100.0%)  Bioshogi::SkillMonitor#execute
# >>       58  (   78.4%)  Bioshogi::SkillMonitor#execute_block
# >>       19  (   25.7%)  Bioshogi::SkillMonitor#execute_one
# >>   callees (73 total):
# >>       74  (  101.4%)  Bioshogi::SkillMonitor#execute_block
# >>       19  (   26.0%)  Bioshogi::SkillMonitor#execute_one
# >>       14  (   19.2%)  Bioshogi::SkillMonitor#soldier_exist?
# >>        8  (   11.0%)  Bioshogi::DefenseInfo#board_parser
# >>        6  (    8.2%)  #<Module:0x00007ff34a109560>#<=>
# >>        5  (    6.8%)  Bioshogi::AttackInfo#board_parser
# >>        4  (    5.5%)  Bioshogi::SkillMonitor#cold_war_verification
# >>        3  (    4.1%)  #<Module:0x00007ff34a12abc0>#<=>
# >>        3  (    4.1%)  Bioshogi::Place#hash
# >>        2  (    2.7%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#hold_piece_eq
# >>        2  (    2.7%)  Bioshogi::SkillMonitor#location
# >>        2  (    2.7%)  Bioshogi::BoardParser::Base#location_adjust
# >>        2  (    2.7%)  block (3 levels) in memory_record
# >>        2  (    2.7%)  Bioshogi::SkillMonitor#surface
# >>        1  (    1.4%)  #<Module:0x00007ff34a14cd60>#<=>
# >>        1  (    1.4%)  Bioshogi::DefenseInfo::AttackInfoSharedMethods#hold_piece_not_in
# >>        1  (    1.4%)  Object#presence
# >>        1  (    1.4%)  Bioshogi::SoldierBox#location_adjust
# >>   code:
# >>                                   |    56  |     def execute_one(e)
# >>    74    (8.0%)                   |    57  |       execute_block(e) do |list|
# >>                                   |    58  |         # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>    10    (1.1%)                   |    59  |         if list.include?(e)
# >>                                   |    60  |           throw :skip
# >>                                   |    61  |         end
# >>                                   |    62  | 
# >>                                   |    63  |         # 「居飛車」判定のとき「振り飛車」がすでにあればスキップ
# >>                                   |    64  |         if e.skip_elements
# >>                                   |    65  |           if e.skip_elements.any? { |e| list.include?(e) }
# >>                                   |    66  |             throw :skip
# >>                                   |    67  |           end
# >>                                   |    68  |         end
# >>                                   |    69  | 
# >>                                   |    70  |         # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>                                   |    71  |         if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    72  |           throw :skip
# >>                                   |    73  |         end
# >>                                   |    74  | 
# >>                                   |    75  |         # 手数制限。制限を超えていたらskip
# >>     1    (0.1%)                   |    76  |         if e.turn_limit
# >>                                   |    77  |           if e.turn_limit < player.container.turn_info.turn_offset.next
# >>                                   |    78  |             throw :skip
# >>                                   |    79  |           end
# >>                                   |    80  |         end
# >>                                   |    81  | 
# >>                                   |    82  |         # 手数限定。手数が異なっていたらskip
# >>                                   |    83  |         if e.turn_eq
# >>                                   |    84  |           if e.turn_eq != player.container.turn_info.turn_offset.next
# >>                                   |    85  |             throw :skip
# >>                                   |    86  |           end
# >>                                   |    87  |         end
# >>                                   |    88  | 
# >>                                   |    89  |         # 手番限定。手番が異なればskip
# >>                                   |    90  |         if e.order_key
# >>                                   |    91  |           if e.order_key != player.container.turn_info.order_key
# >>                                   |    92  |             throw :skip
# >>                                   |    93  |           end
# >>                                   |    94  |         end
# >>                                   |    95  | 
# >>                                   |    96  |         # 開戦済みならskip
# >>     4    (0.4%)                   |    97  |         cold_war_verification(e)
# >>                                   |    98  | 
# >>                                   |    99  |         # 「打」時制限。移動元駒があればskip
# >>                                   |   100  |         if e.drop_only
# >>                                   |   101  |           if origin_soldier
# >>                                   |   102  |             throw :skip
# >>                                   |   103  |           end
# >>                                   |   104  |         end
# >>                                   |   105  | 
# >>                                   |   106  |         # 駒を取ったとき制限。取ってないならskip
# >>                                   |   107  |         if e.kill_only
# >>                                   |   108  |           if !executor.captured_soldier
# >>                                   |   109  |             throw :skip
# >>                                   |   110  |           end
# >>                                   |   111  |         end
# >>                                   |   112  | 
# >>                                   |   113  |         # 所持駒数一致制限。異なっていたらskip
# >>     1    (0.1%)                   |   114  |         if v = e.hold_piece_empty
# >>                                   |   115  |           if !player.piece_box.empty?
# >>                                   |   116  |             throw :skip
# >>                                   |   117  |           end
# >>                                   |   118  |         end
# >>                                   |   119  | 
# >>                                   |   120  |         if true
# >>                                   |   121  |           # 何もない制限。何かあればskip
# >>     3    (0.3%)                   |   122  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["○"]
# >>     5    (0.5%)                   |   123  |             ary.each do |e|
# >>     5    (0.5%)                   |   124  |               if surface[e[:place]]
# >>                                   |   125  |                 throw :skip
# >>                                   |   126  |               end
# >>                                   |   127  |             end
# >>                                   |   128  |           end
# >>                                   |   129  | 
# >>                                   |   130  |           # 何かある制限。何もなければskip
# >>     3    (0.3%)                   |   131  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["●"]
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
# >>                                   |   142  |           if ary = e.board_parser.other_objects_loc_ary[location.key]["☆"]
# >>                                   |   143  |             # 移動元についての指定があるのに移動元がない場合はそもそも状況が異なるのでskip
# >>                                   |   144  |             if !origin_soldier
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
# >>     3    (0.3%) /     1   (0.1%)  |   155  |           if places_hash = e.board_parser.other_objects_loc_places_hash[location.key]["★"]
# >>                                   |   156  |             # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   157  |             if !origin_soldier
# >>                                   |   158  |               throw :skip
# >>                                   |   159  |             end
# >>                                   |   160  |             if places_hash[origin_soldier.place]
# >>                                   |   161  |               # 移動元があったのでOK
# >>                                   |   162  |             else
# >>                                   |   163  |               throw :skip
# >>                                   |   164  |             end
# >>                                   |   165  |           end
# >>                                   |   166  |         end
# >>                                   |   167  | 
# >>                                   |   168  |         # 自分の金or銀がある
# >>     3    (0.3%)                   |   169  |         if ary = e.board_parser.other_objects_loc_ary[location.key]["◆"]
# >>                                   |   170  |           ary.each do |e|
# >>                                   |   171  |             if !worth_more_gteq_silver?(e[:place])
# >>                                   |   172  |               throw :skip
# >>                                   |   173  |             end
# >>                                   |   174  |           end
# >>                                   |   175  |         end
# >>                                   |   176  | 
# >>                                   |   177  |         # 自分の歩以上の駒がある
# >>                                   |   178  |         if ary = e.board_parser.other_objects_loc_ary[location.key]["◇"]
# >>                                   |   179  |           ary.each do |e|
# >>                                   |   180  |             if !worth_more_gteq_pawn?(e[:place])
# >>                                   |   181  |               throw :skip
# >>                                   |   182  |             end
# >>                                   |   183  |           end
# >>                                   |   184  |         end
# >>                                   |   185  | 
# >>                                   |   186  |         # 歩を持っていたらskip
# >>                                   |   187  |         if e.not_have_pawn
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
# >>     2    (0.2%)                   |   202  |           if v = e.hold_piece_eq
# >>                                   |   203  |             if piece_box != v
# >>                                   |   204  |               throw :skip
# >>                                   |   205  |             end
# >>                                   |   206  |           end
# >>                                   |   207  | 
# >>                                   |   208  |           # 指定の駒をすべて含んでいるならOK
# >>                                   |   209  |           if v = e.hold_piece_in
# >>                                   |   210  |             if v.all? { |piece_key, _| piece_box.has_key?(piece_key) }
# >>                                   |   211  |             else
# >>                                   |   212  |               throw :skip
# >>                                   |   213  |             end
# >>                                   |   214  |           end
# >>                                   |   215  | 
# >>                                   |   216  |           # 指定の駒をどれか含んでいるならskip
# >>     1    (0.1%)                   |   217  |           if v = e.hold_piece_not_in
# >>                                   |   218  |             if v.any? { |piece_key, _| piece_box.has_key?(piece_key) }
# >>                                   |   219  |               throw :skip
# >>                                   |   220  |             end
# >>                                   |   221  |           end
# >>                                   |   222  |         end
# >>                                   |   223  | 
# >>                                   |   224  |         # どれかが盤上に正確に含まれるならOK
# >>     6    (0.7%)                   |   225  |         if ary = e.board_parser.any_exist_soldiers.location_adjust[location.key].presence
# >>     4    (0.4%)                   |   226  |           if ary.any? { |e| soldier_exist?(e) }
# >>                                   |   227  |           else
# >>                                   |   228  |             throw :skip
# >>                                   |   229  |           end
# >>                                   |   230  |         end
# >>                                   |   231  | 
# >>                                   |   232  |         # 指定の配置が盤上に含まれるならOK
# >>     2    (0.2%)                   |   233  |         ary = e.board_parser.location_adjust[location.key]
# >>    24    (2.6%)                   |   234  |         if ary.all? { |e| soldier_exist?(e) }
# >>                                   |   235  |         else
# >> Bioshogi::SkillMonitor#execute (/Users/ikeda/src/bioshogi/lib/bioshogi/skill_monitor.rb:13)
# >>   samples:     0 self (0.0%)  /    196 total (21.3%)
# >>   callers:
# >>      196  (  100.0%)  Bioshogi::PlayerExecutor::Human#perform_skill_monitor
# >>       83  (   42.3%)  Bioshogi::SkillMonitor#execute
# >>        7  (    3.6%)  Bioshogi::SkillMonitor#execute_block
# >>   callees (196 total):
# >>       83  (   42.3%)  Bioshogi::SkillMonitor#execute
# >>       78  (   39.8%)  Bioshogi::TacticInfo.soldier_hash_table
# >>       74  (   37.8%)  Bioshogi::SkillMonitor#execute_one
# >>       17  (    8.7%)  Bioshogi::SkillMonitor#soldier
# >>       12  (    6.1%)  Bioshogi::Soldier#hash
# >>        9  (    4.6%)  Bioshogi::SkillMonitor#execute_block
# >>        4  (    2.0%)  Bioshogi::Soldier#eql?
# >>        2  (    1.0%)  block in <class:TechniqueMatcherInfo>
# >>        2  (    1.0%)  block in <class:TechniqueMatcherInfo>
# >>        1  (    0.5%)  block in <class:TechniqueMatcherInfo>
# >>        1  (    0.5%)  Bioshogi::PlayerExecutor::Base#container
# >>        1  (    0.5%)  block in <class:TechniqueMatcherInfo>
# >>        1  (    0.5%)  block in <class:TechniqueMatcherInfo>
# >>        1  (    0.5%)  Bioshogi::TacticInfo.piece_hash_table
# >>   code:
# >>                                   |    13  |     def execute
# >>   111   (12.1%)                   |    14  |       if e = Explain::TacticInfo.soldier_hash_table[soldier]
# >>    74    (8.0%)                   |    15  |         e.each do |e|
# >>                                   |    16  |           walk_counts[e.key] += 1
# >>    74    (8.0%)                   |    17  |           execute_one(e)
# >>                                   |    18  |         end
# >>                                   |    19  |       end
# >>                                   |    20  | 
# >>     1    (0.1%)                   |    21  |       if executor.container.params[:skill_monitor_technique_enable]
# >>                                   |    22  |         # 主に手筋用で戦型チェックにも使える
# >>                                   |    23  |         key = [soldier.piece.key, soldier.promoted, !!executor.drop_hand]
# >>     1    (0.1%)                   |    24  |         if e = Explain::TacticInfo.piece_hash_table[key]
# >>     9    (1.0%)                   |    25  |           e.each do |e|
# >>     9    (1.0%)                   |    26  |             execute_block(e) do |list|
# >>                                   |    27  |               walk_counts[e.key] += 1
# >>                                   |    28  |               cold_war_verification(e)
# >>     7    (0.8%)                   |    29  |               instance_eval(&e.technique_matcher_info.verify_process)
# >>                                   |    30  |             end
