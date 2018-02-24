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
    info = mediator.current_player.brain.nega_alpha_run(depth_max: 2)
    hand = info[:hand]
    mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
  end
end
puts mediator
tp Warabi.exec_counts

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Warabi::Point.lookup"

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
# >> |-------------------------+------|
# >> ==================================
# >>   Mode: wall(1000)
# >>   Samples: 606 (0.00% miss rate)
# >>   GC: 86 (14.19%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>         93  (15.3%)          93  (15.3%)     block (4 levels) in memory_record
# >>         86  (14.2%)          86  (14.2%)     (garbage collection)
# >>         39   (6.4%)          39   (6.4%)     Warabi::Position::Base#hash
# >>         25   (4.1%)          25   (4.1%)     Warabi::Point#to_xy
# >>         47   (7.8%)          24   (4.0%)     Warabi::Point#hash
# >>         24   (4.0%)          24   (4.0%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>         21   (3.5%)          21   (3.5%)     Warabi::Piece::ScoreMethods#piece_score
# >>         21   (3.5%)          21   (3.5%)     Hash#transform_keys
# >>         77  (12.7%)          17   (2.8%)     Warabi::Point.lookup
# >>         19   (3.1%)          17   (2.8%)     Warabi::PieceVector#all_vectors
# >>         16   (2.6%)          16   (2.6%)     Warabi::Position::Base.lookup
# >>        474  (78.2%)          15   (2.5%)     Warabi::Movabler#move_list
# >>         32   (5.3%)          14   (2.3%)     ActiveModel::AttributeAssignment#assign_attributes
# >>         82  (13.5%)          14   (2.3%)     Warabi::MediatorPlayers#basic_score
# >>         10   (1.7%)          10   (1.7%)     Warabi::Piece::VectorMethods#piece_vector
# >>        484  (79.9%)          10   (1.7%)     Warabi::NegaAlphaExecuter#nega_alpha
# >>         20   (3.3%)           9   (1.5%)     Warabi::Board::UpdateMethods#put_on
# >>          9   (1.5%)           9   (1.5%)     Warabi::Position::Base.value_range
# >>          9   (1.5%)           9   (1.5%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>         51   (8.4%)           9   (1.5%)     ActiveModel::AttributeAssignment#assign_attributes
# >>          7   (1.2%)           7   (1.2%)     Warabi::Evaluator#initialize
# >>        470  (77.6%)           7   (1.2%)     Warabi::Brain#move_hands
# >>          6   (1.0%)           6   (1.0%)     Warabi::MediatorBase#board
# >>          6   (1.0%)           6   (1.0%)     Warabi::Soldier#attributes
# >>         27   (4.5%)           6   (1.0%)     Warabi::MoveHand#execute
# >>          5   (0.8%)           5   (0.8%)     #<Module:0x00007fda0982f7b8>.exec_counts
# >>         14   (2.3%)           5   (0.8%)     Warabi::Position::Base#valid?
# >>          5   (0.8%)           5   (0.8%)     Warabi::Board#surface
# >>          4   (0.7%)           4   (0.7%)     ActiveModel::ForbiddenAttributesProtection#sanitize_for_mass_assignment
# >>          4   (0.7%)           4   (0.7%)     Warabi::Location#flip
# >> Warabi::Point.lookup (/Users/ikeda/src/warabi/lib/warabi/point.rb:30)
# >>   samples:    17 self (2.8%)  /     77 total (12.7%)
# >>   callers:
# >>       57  (   74.0%)  Warabi::Point.fetch
# >>       20  (   26.0%)  Warabi::Point.[]
# >>   callees (60 total):
# >>       39  (   65.0%)  Warabi::Position::Base#hash
# >>       13  (   21.7%)  Warabi::Position::Hpos.lookup
# >>        8  (   13.3%)  Warabi::Position::Vpos.lookup
# >>   code:
# >>                                   |    30  |       def lookup(value)
# >>     7    (1.2%) /     7   (1.2%)  |    31  |         if value.kind_of?(self)
# >>                                   |    32  |           return value
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>                                   |    35  |         x = nil
# >>                                   |    36  |         y = nil
# >>                                   |    37  | 
# >>                                   |    38  |         case value
# >>                                   |    39  |         when Array
# >>                                   |    40  |           a, b = value
# >>    13    (2.1%)                   |    41  |           x = Position::Hpos.lookup(a)
# >>     8    (1.3%)                   |    42  |           y = Position::Vpos.lookup(b)
# >>                                   |    43  |         when String
# >>                                   |    44  |           a, b = value.chars
# >>                                   |    45  |           x = Position::Hpos.lookup(a)
# >>                                   |    46  |           y = Position::Vpos.lookup(b)
# >>                                   |    47  |         end
# >>                                   |    48  | 
# >>                                   |    49  |         if x && y
# >>     3    (0.5%) /     3   (0.5%)  |    50  |           @memo ||= {}
# >>    16    (2.6%) /     2   (0.3%)  |    51  |           @memo[x] ||= {}
# >>    29    (4.8%) /     4   (0.7%)  |    52  |           @memo[x][y] ||= new(x, y).freeze
# >>                                   |    53  |         end
# >>     1    (0.2%) /     1   (0.2%)  |    54  |       end
# >>                                   |    55  | 
