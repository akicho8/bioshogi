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

# system "stackprof stackprof.dump --method Bushido::Point.fetch"
# system "stackprof stackprof.dump --method Bushido::Movabler#movable_infos"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 4287.8 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 869 (0.00% miss rate)
# >>   GC: 166 (19.10%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        166  (19.1%)         166  (19.1%)     (garbage collection)
# >>         80   (9.2%)          79   (9.1%)     Bushido::Position::Base.lookup
# >>         42   (4.8%)          42   (4.8%)     block (4 levels) in memory_record
# >>        136  (15.7%)          41   (4.7%)     Bushido::Point.lookup
# >>        264  (30.4%)          39   (4.5%)     Bushido::SkillMonitor#execute
# >>         32   (3.7%)          32   (3.7%)     Bushido::Battler#to_soldier
# >>         43   (4.9%)          31   (3.6%)     Bushido::Parser#file_parse
# >>         31   (3.6%)          31   (3.6%)     Bushido::Point#to_xy
# >>         27   (3.1%)          27   (3.1%)     Bushido::Piece::VectorMethods#select_vectors2
# >>         14   (1.6%)          14   (1.6%)     Bushido::Point#initialize
# >>         13   (1.5%)          13   (1.5%)     Bushido::Position::Base.units
# >>         12   (1.4%)          12   (1.4%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         27   (3.1%)          12   (1.4%)     Bushido::Point#eql?
# >>         49   (5.6%)          11   (1.3%)     Bushido::Movabler#piece_store
# >>         21   (2.4%)          10   (1.2%)     Bushido::Point#hash
# >>         26   (3.0%)           9   (1.0%)     Bushido::Soldier#reverse
# >>         11   (1.3%)           9   (1.0%)     ActiveSupport::Duration::Scalar#-
# >>         10   (1.2%)           9   (1.0%)     Hash#transform_keys
# >>          8   (0.9%)           8   (0.9%)     Bushido::Parser::Base::ConverterMethods#mb_ljust
# >>         75   (8.6%)           8   (0.9%)     Bushido::BoardParser::KifBoardParser#cell_walker
# >>         83   (9.6%)           8   (0.9%)     Bushido::ShapeInfo#board_parser
# >>         13   (1.5%)           8   (0.9%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>        183  (21.1%)           8   (0.9%)     Bushido::Runner#execute
# >>          7   (0.8%)           7   (0.8%)     Hash#slice
# >>          7   (0.8%)           7   (0.8%)     #<Module:0x007fa484350e50>.kconv
# >>          7   (0.8%)           7   (0.8%)     ActiveSupport::Duration#respond_to_missing?
# >>         12   (1.4%)           6   (0.7%)     Bushido::Position::Base#valid?
# >>          6   (0.7%)           6   (0.7%)     Bushido::Position::Base.value_range
# >>          8   (0.9%)           6   (0.7%)     ActiveSupport::Duration.===
# >>         13   (1.5%)           6   (0.7%)     Bushido::Parser#source_normalize
# >> Bushido::SkillMonitor#execute (/Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:11)
# >>   samples:    39 self (4.5%)  /    264 total (30.4%)
# >>   callers:
# >>      440  (  166.7%)  Bushido::SkillMonitor#execute
# >>      264  (  100.0%)  Bushido::Player#execute
# >>   callees (225 total):
# >>      440  (  195.6%)  Bushido::SkillMonitor#execute
# >>       68  (   30.2%)  Bushido::TacticInfo.all_soldier_points_hash
# >>       42  (   18.7%)  Bushido::SkillMonitor#cached_board_soldiers
# >>       19  (    8.4%)  Bushido::AttackInfo#board_parser
# >>       14  (    6.2%)  Bushido::Point#==
# >>       14  (    6.2%)  Bushido::DefenseInfo#board_parser
# >>       14  (    6.2%)  Bushido::Point#reverse_if_white
# >>       13  (    5.8%)  block (4 levels) in memory_record
# >>       10  (    4.4%)  Bushido::Board::ReaderMethods#[]
# >>        5  (    2.2%)  Bushido::TacticInfo#var_key
# >>        5  (    2.2%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        4  (    1.8%)  Bushido::SkillMonitor#current_soldier
# >>        4  (    1.8%)  Bushido::Player::SkillMonitorMethods#skill_set
# >>        2  (    0.9%)  Object#presence
# >>        2  (    0.9%)  Object#present?
# >>        2  (    0.9%)  Bushido::BoardParser::FireBoardParser#trigger_soldiers_hash
# >>        2  (    0.9%)  Bushido::DefenseInfo::AttackInfoSharedMethods#tactic_info
# >>        1  (    0.4%)  Bushido::SkillSet#defense_infos
# >>        1  (    0.4%)  Bushido::DefenseInfo::AttackInfoSharedMethods#gentei_match_any
# >>        1  (    0.4%)  Bushido::Point#eql?
# >>        1  (    0.4%)  Bushido::Soldier#point
# >>        1  (    0.4%)  Bushido::Point#hash
# >>   code:
# >>                                   |    11  |     def execute
# >>                                   |    12  |       # 戦法リストをeachするのではなく移動先に配置がある戦法だけを取得
# >>    72    (8.3%)                   |    13  |       elements = TacticInfo.all_soldier_points_hash[current_soldier[:point]] || []
# >>                                   |    14  | 
# >>   192   (22.1%)                   |    15  |       elements.each do |e|
# >>    17    (2.0%)                   |    16  |         list = player.skill_set.public_send(e.tactic_info.var_key)
# >>   175   (20.1%) /     1   (0.1%)  |    17  |         catch :skip do
# >>                                   |    18  |           # 美濃囲いがすでに完成していれば美濃囲いチェックはスキップ
# >>     1    (0.1%) /     1   (0.1%)  |    19  |           if list.include?(e)
# >>                                   |    20  |             throw :skip
# >>                                   |    21  |           end
# >>                                   |    22  | 
# >>                                   |    23  |           # 片美濃のチェックをしようとするとき、すでに子孫のダイヤモンド美濃があれば、片美濃のチェックはスキップ
# >>                                   |    24  |           if e.cached_descendants.any? { |e| list.include?(e) }
# >>                                   |    25  |             throw :skip
# >>                                   |    26  |           end
# >>                                   |    27  | 
# >>     2    (0.2%)                   |    28  |           if e.turn_limit
# >>                                   |    29  |             if e.turn_limit < player.mediator.turn_info.counter.next
# >>                                   |    30  |               throw :skip
# >>                                   |    31  |             end
# >>                                   |    32  |           end
# >>                                   |    33  | 
# >>     3    (0.3%)                   |    34  |           if e.turn_eq
# >>                                   |    35  |             if e.turn_eq != player.mediator.turn_info.counter.next
# >>                                   |    36  |               throw :skip
# >>                                   |    37  |             end
# >>                                   |    38  |           end
# >>                                   |    39  | 
# >>     2    (0.2%)                   |    40  |           if e.teban_eq
# >>                                   |    41  |             if e.teban_eq != player.mediator.turn_info.senteban_or_goteban
# >>                                   |    42  |               throw :skip
# >>                                   |    43  |             end
# >>                                   |    44  |           end
# >>                                   |    45  | 
# >>     3    (0.3%)                   |    46  |           if e.kaisenmae
# >>     1    (0.1%) /     1   (0.1%)  |    47  |             if player.mediator.kill_counter.positive?
# >>                                   |    48  |               throw :skip
# >>                                   |    49  |             end
# >>                                   |    50  |           end
# >>                                   |    51  | 
# >>     1    (0.1%)                   |    52  |           if e.stroke_only
# >>                                   |    53  |             if player.runner.before_soldier
# >>                                   |    54  |               throw :skip
# >>                                   |    55  |             end
# >>                                   |    56  |           end
# >>                                   |    57  | 
# >>     1    (0.1%)                   |    58  |           if e.kill_only
# >>                                   |    59  |             unless player.runner.tottakoma
# >>                                   |    60  |               throw :skip
# >>                                   |    61  |             end
# >>                                   |    62  |           end
# >>                                   |    63  | 
# >>     1    (0.1%)                   |    64  |           if v = e.hold_piece_count_eq
# >>                                   |    65  |             if player.pieces.size != v
# >>                                   |    66  |               throw :skip
# >>                                   |    67  |             end
# >>                                   |    68  |           end
# >>                                   |    69  | 
# >>                                   |    70  |           # 何もない
# >>     9    (1.0%)                   |    71  |           if ary = e.board_parser.other_objects_hash_ary["○"]
# >>    24    (2.8%)                   |    72  |             ary.each do |obj|
# >>    13    (1.5%)                   |    73  |               pt = obj[:point].reverse_if_white(player.location)
# >>    10    (1.2%)                   |    74  |               if player.board[pt]
# >>     1    (0.1%) /     1   (0.1%)  |    75  |                 throw :skip
# >>                                   |    76  |               end
# >>                                   |    77  |             end
# >>                                   |    78  |           end
# >>                                   |    79  | 
# >>                                   |    80  |           # 何かある
# >>     9    (1.0%)                   |    81  |           if ary = e.board_parser.other_objects_hash_ary["●"]
# >>                                   |    82  |             ary.each do |obj|
# >>                                   |    83  |               pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    84  |               if !player.board[pt]
# >>                                   |    85  |                 throw :skip
# >>                                   |    86  |               end
# >>                                   |    87  |             end
# >>                                   |    88  |           end
# >>                                   |    89  | 
# >>                                   |    90  |           # 移動元ではない
# >>     5    (0.6%)                   |    91  |           if ary = e.board_parser.other_objects_hash_ary["☆"]
# >>                                   |    92  |             ary.each do |obj|
# >>                                   |    93  |               pt = obj[:point].reverse_if_white(player.location)
# >>                                   |    94  |               before_soldier = player.runner.before_soldier
# >>                                   |    95  |               if before_soldier && pt == before_soldier.point
# >>                                   |    96  |                 throw :skip
# >>                                   |    97  |               end
# >>                                   |    98  |             end
# >>                                   |    99  |           end
# >>                                   |   100  | 
# >>                                   |   101  |           # 移動元(any条件)
# >>     3    (0.3%)                   |   102  |           ary = e.board_parser.other_objects_hash_ary["★"]
# >>     2    (0.2%)                   |   103  |           if ary.present?
# >>                                   |   104  |             before_soldier = player.runner.before_soldier
# >>                                   |   105  |             if !before_soldier
# >>                                   |   106  |               # 移動元がないということは、もう何も該当しないので skip
# >>                                   |   107  |               throw :skip
# >>                                   |   108  |             end
# >>     3    (0.3%)                   |   109  |             if ary.any? { |e|
# >>     1    (0.1%)                   |   110  |                 pt = e[:point].reverse_if_white(player.location)
# >>     2    (0.2%)                   |   111  |                 pt == before_soldier.point
# >>                                   |   112  |               }
# >>                                   |   113  |             else
# >>                                   |   114  |               throw :skip
# >>                                   |   115  |             end
# >>                                   |   116  |           end
# >>                                   |   117  | 
# >>                                   |   118  |           if e.fuganai
# >>                                   |   119  |             if player.pieces.include?(Piece.fetch(:pawn))
# >>                                   |   120  |               throw :skip
# >>                                   |   121  |             end
# >>                                   |   122  |           end
# >>                                   |   123  | 
# >>                                   |   124  |           if e.fu_igai_mottetara_dame
# >>                                   |   125  |             unless (player.pieces - [Piece.fetch(:pawn)]).empty?
# >>                                   |   126  |               throw :skip
# >>                                   |   127  |             end
# >>                                   |   128  |           end
# >>                                   |   129  | 
# >>                                   |   130  |           if v = e.hold_piece_eq
# >>                                   |   131  |             if player.pieces.sort != v.sort
# >>                                   |   132  |               throw :skip
# >>                                   |   133  |             end
# >>                                   |   134  |           end
# >>                                   |   135  | 
# >>                                   |   136  |           if v = e.hold_piece_in
# >>                                   |   137  |             unless v.all? {|x| player.pieces.include?(x) }
# >>                                   |   138  |               throw :skip
# >>                                   |   139  |             end
# >>                                   |   140  |           end
# >>                                   |   141  | 
# >>                                   |   142  |           if v = e.hold_piece_not_in
# >>                                   |   143  |             if v.any? {|x| player.pieces.include?(x) }
# >>                                   |   144  |               throw :skip
# >>                                   |   145  |             end
# >>                                   |   146  |           end
# >>                                   |   147  | 
# >>     2    (0.2%)                   |   148  |           if v = e.board_parser.trigger_soldiers_hash.presence
# >>                                   |   149  |             # トリガー駒が用意されているのに、その座標に移動先が含まれていなかったら即座に skip
# >>     2    (0.2%)                   |   150  |             soldier = v[current_soldier[:point]]
# >>                                   |   151  |             unless soldier
# >>                                   |   152  |               throw :skip
# >>                                   |   153  |             end
# >>                                   |   154  |             # 駒や状態まで判定する
# >>     1    (0.1%) /     1   (0.1%)  |   155  |             if soldier != current_soldier
# >>                                   |   156  |               throw :skip
# >>                                   |   157  |             end
# >>                                   |   158  |           end
# >>                                   |   159  | 
# >>    42    (4.8%)                   |   160  |           soldiers = cached_board_soldiers(e)
# >>                                   |   161  | 
# >>                                   |   162  |           # どれかが盤上に含まれる (後手の飛車の位置などはこれでしか指定できない→「?」を使う)
# >>     1    (0.1%)                   |   163  |           if v = e.gentei_match_any
# >>                                   |   164  |             if v.any? {|o| soldiers.include?(o) }
# >>                                   |   165  |             else
# >>                                   |   166  |               throw :skip
# >>                                   |   167  |             end
# >>                                   |   168  |           end
# >>                                   |   169  | 
# >>                                   |   170  |           # どれかが盤上に含まれる
# >>     5    (0.6%)                   |   171  |           if v = e.board_parser.any_exist_soldiers.presence
# >>     4    (0.5%) /     2   (0.2%)  |   172  |             if v.any? {|o| soldiers.include?(o) }
# >>                                   |   173  |             else
# >>                                   |   174  |               throw :skip
# >>                                   |   175  |             end
# >>                                   |   176  |           end
# >>                                   |   177  | 
# >>    94   (10.8%) /    32   (3.7%)  |   178  |           if e.board_parser.soldiers.all? { |e| soldiers.include?(e) }
# >>                                   |   179  |             list << e
