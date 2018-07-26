require "./example_helper"

# mediator = Mediator.start
# mediator.execute("▲６八銀")
# mediator.instance_variables     # => [:@board, :@turn_info, :@players, :@first_state_board_sfen, :@variables, :@var_stack, :@params, :@hand_logs]
# 
# mediator = MediatorSimple.start
# mediator.execute("▲６八銀")
# mediator.instance_variables     # => 

# Warabi.logger = ActiveSupport::Logger.new(STDOUT)

mediator = Mediator.start

StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do
  50.times do
    v, pv = mediator.current_player.brain.diver_dive(depth_max: 2)
    hand = pv.first
    mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
  end
end
puts mediator
tp Warabi.run_counts

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Warabi::Place.lookup"

# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・v金v銀v香|一
# >> | ・v飛 ・ ・v玉v金 ・v角 ・|二
# >> |v香 ・v桂v銀v歩v歩v歩v歩v桂|三
# >> |v歩v歩v歩v歩 ・ ・ ・ ・v歩|四
# >> | ・ ・ ・ ・ 歩 歩 歩 ・ ・|五
# >> | 歩 歩 歩 歩 ・ ・ ・ 歩 歩|六
# >> | 角 銀 玉 ・ ・ ・ ・ ・ 香|七
# >> | 香 ・ ・ ・ 金 銀 飛 ・ ・|八
# >> | ・ 桂 ・ 金 ・ ・ ・ 桂 ・|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝50 △６三銀(62) まで
# >> 
# >> 先手番
# >> |-------------------------+------|
# >> | Warabi::MoveHand.create | 5316 |
# >> | sandbox_execute.execute | 5041 |
# >> |  sandbox_execute.revert | 5041 |
# >> |-------------------------+------|
# >> ==================================
# >>   Mode: wall(1000)
# >>   Samples: 704 (0.00% miss rate)
# >>   GC: 108 (15.34%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        108  (15.3%)         108  (15.3%)     (garbage collection)
# >>         80  (11.4%)          80  (11.4%)     block (4 levels) in memory_record
# >>         93  (13.2%)          38   (5.4%)     Warabi::Place.lookup
# >>         31   (4.4%)          31   (4.4%)     Hash#transform_keys
# >>         29   (4.1%)          29   (4.1%)     Warabi::Dimension::Base#hash
# >>        551  (78.3%)          28   (4.0%)     Warabi::Movabler#move_list
# >>         28   (4.0%)          28   (4.0%)     Warabi::PieceVector#all_vectors
# >>         47   (6.7%)          27   (3.8%)     Warabi::Place#hash
# >>         24   (3.4%)          24   (3.4%)     Warabi::Piece::ScoreMethods#piece_score
# >>         24   (3.4%)          24   (3.4%)     Warabi::Dimension::Base.lookup
# >>         49   (7.0%)          21   (3.0%)     ActiveModel::AttributeAssignment#assign_attributes
# >>         20   (2.8%)          20   (2.8%)     Warabi::Place#to_xy
# >>        556  (79.0%)          17   (2.4%)     Warabi::NegaAlphaDiver#dive
# >>         14   (2.0%)          14   (2.0%)     Warabi::Soldier#attributes
# >>         13   (1.8%)          13   (1.8%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>         45   (6.4%)          13   (1.8%)     ActiveModel::AttributeAssignment#assign_attributes
# >>         91  (12.9%)          12   (1.7%)     Warabi::MediatorPlayers#basic_score
# >>         12   (1.7%)          12   (1.7%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>        541  (76.8%)          10   (1.4%)     Warabi::Brain#move_hands
# >>         24   (3.4%)          10   (1.4%)     Warabi::Board::UpdateMethods#place_on
# >>          9   (1.3%)           9   (1.3%)     Warabi::Dimension::Base.value_range
# >>         18   (2.6%)           9   (1.3%)     Warabi::Dimension::Base#valid?
# >>          8   (1.1%)           8   (1.1%)     #<Module:0x00007fa66a13bdd0>.run_counts
# >>          8   (1.1%)           8   (1.1%)     Warabi::MediatorBase#board
# >>        556  (79.0%)           8   (1.1%)     Warabi::Brain#normal_all_hands
# >>         46   (6.5%)           7   (1.0%)     Warabi::Piece#basic_weight
# >>          7   (1.0%)           7   (1.0%)     Warabi::Piece::VectorMethods#piece_vector
# >>          6   (0.9%)           6   (0.9%)     Warabi::Board#surface
# >>        437  (62.1%)           5   (0.7%)     Set#each
# >>          5   (0.7%)           5   (0.7%)     SimpleDelegator#__getobj__
# >> Warabi::Place.lookup (/Users/ikeda/src/warabi/lib/warabi/place.rb:30)
# >>   samples:    38 self (5.4%)  /     93 total (13.2%)
# >>   callers:
# >>       72  (   77.4%)  Warabi::Place.fetch
# >>       21  (   22.6%)  Warabi::Place.[]
# >>   callees (55 total):
# >>       29  (   52.7%)  Warabi::Dimension::Base#hash
# >>       15  (   27.3%)  Warabi::Dimension::Yplace.lookup
# >>       11  (   20.0%)  Warabi::Dimension::Xplace.lookup
# >>   code:
# >>                                   |    30  |       def lookup(value)
# >>    24    (3.4%) /    24   (3.4%)  |    31  |         if value.kind_of?(self)
# >>                                   |    32  |           return value
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>                                   |    35  |         x = nil
# >>                                   |    36  |         y = nil
# >>                                   |    37  | 
# >>                                   |    38  |         case value
# >>     3    (0.4%) /     3   (0.4%)  |    39  |         when Array
# >>                                   |    40  |           a, b = value
# >>    14    (2.0%)                   |    41  |           x = Dimension::Yplace.lookup(a)
# >>     8    (1.1%)                   |    42  |           y = Dimension::Xplace.lookup(b)
# >>                                   |    43  |         when String
# >>                                   |    44  |           a, b = value.chars
# >>     1    (0.1%)                   |    45  |           x = Dimension::Yplace.lookup(a)
# >>     3    (0.4%)                   |    46  |           y = Dimension::Xplace.lookup(b)
# >>                                   |    47  |         end
# >>                                   |    48  | 
# >>                                   |    49  |         if x && y
# >>                                   |    50  |           @memo ||= {}
# >>    15    (2.1%) /     4   (0.6%)  |    51  |           @memo[x] ||= {}
# >>    23    (3.3%) /     5   (0.7%)  |    52  |           @memo[x][y] ||= new(x, y).freeze
# >>                                   |    53  |         end
# >>     2    (0.3%) /     2   (0.3%)  |    54  |       end
# >>                                   |    55  | 
