require "./example_helper"
require "stackprof"

mediator = Mediator.start
mediator.execute("▲６八銀")
mediator.instance_variables     # => [:@board, :@turn_info, :@players, :@first_state_board_sfen, :@variables, :@var_stack, :@params, :@hand_logs]

mediator = MediatorSimple.start
mediator.execute("▲６八銀")
mediator.instance_variables     # => [:@board, :@turn_info, :@players, :@first_state_board_sfen]

# Warabi.logger = ActiveSupport::Logger.new(STDOUT)

mediator = Mediator.new
mediator.pieces_set("▲歩△歩")
mediator.board.placement_from_shape <<~EOT
+------+
|v飛v香|
| ・ ・|
| ・v歩|
|v香 ・|
|v歩 歩|
| ・ 香|
| 歩 ・|
| ・ ・|
| 香 飛|
+------+
  EOT


StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
  2.times do
    info = mediator.current_player.brain.nega_max_run(depth_max: 1)
    hand = info[:hand]
    mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)
  end
end

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Warabi::Point.lookup"

# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 1472 (0.00% miss rate)
# >>   GC: 187 (12.70%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        561  (38.1%)         434  (29.5%)     Warabi::MediatorMemento#create_memento
# >>        187  (12.7%)         187  (12.7%)     (garbage collection)
# >>        142   (9.6%)         142   (9.6%)     Warabi::Point#to_xy
# >>         65   (4.4%)          65   (4.4%)     block (4 levels) in memory_record
# >>         69   (4.7%)          61   (4.1%)     Hash#transform_keys
# >>         56   (3.8%)          54   (3.7%)     Warabi::Position::Base.lookup
# >>        189  (12.8%)          51   (3.5%)     Warabi::Point#hash
# >>         46   (3.1%)          46   (3.1%)     Warabi::Position::Base#hash
# >>         46   (3.1%)          46   (3.1%)     Warabi::Soldier#attributes
# >>        136   (9.2%)          38   (2.6%)     Warabi::Soldier#hash
# >>        151  (10.3%)          36   (2.4%)     Warabi::Point.lookup
# >>         23   (1.6%)          23   (1.6%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>         17   (1.2%)          16   (1.1%)     Warabi::PieceVector#all_vectors
# >>         13   (0.9%)          13   (0.9%)     SimpleDelegator#__getobj__
# >>         17   (1.2%)          13   (0.9%)     Warabi::InputAdapter::UsiAdapter#alpha_to_digit
# >>         55   (3.7%)          11   (0.7%)     ActiveModel::AttributeAssignment#assign_attributes
# >>         10   (0.7%)          10   (0.7%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         13   (0.9%)           9   (0.6%)     Warabi::InputParser#match!
# >>          8   (0.5%)           8   (0.5%)     Warabi::Position::Base.value_range
# >>         35   (2.4%)           8   (0.5%)     Hash#symbolize_keys
# >>          8   (0.5%)           8   (0.5%)     Warabi::MediatorBase#board
# >>          7   (0.5%)           7   (0.5%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>          7   (0.5%)           7   (0.5%)     Warabi::Piece::VectorMethods#piece_vector
# >>          6   (0.4%)           6   (0.4%)     Warabi::Player::PieceBoxMethods#piece_box
# >>        154  (10.5%)           6   (0.4%)     Warabi::Player#candidate_soldiers
# >>          8   (0.5%)           6   (0.4%)     Warabi::Piece::ScoreMethods#piece_score
# >>         26   (1.8%)           6   (0.4%)     ActiveModel::AttributeAssignment#assign_attributes
# >>         24   (1.6%)           6   (0.4%)     Warabi::Position::Hpos.lookup
# >>          7   (0.5%)           5   (0.3%)     Delegator#marshal_dump
# >>         47   (3.2%)           5   (0.3%)     Warabi::Position::Vpos.lookup
# >> Warabi::Point.lookup (/Users/ikeda/src/warabi/lib/warabi/point.rb:30)
# >>   samples:    36 self (2.4%)  /    151 total (10.3%)
# >>   callers:
# >>      143  (   94.7%)  Warabi::Point.fetch
# >>        8  (    5.3%)  Warabi::Point.[]
# >>   callees (115 total):
# >>       46  (   40.0%)  Warabi::Position::Base#hash
# >>       45  (   39.1%)  Warabi::Position::Vpos.lookup
# >>       24  (   20.9%)  Warabi::Position::Hpos.lookup
# >>   code:
# >>                                   |    30  |       def lookup(value)
# >>    15    (1.0%) /    15   (1.0%)  |    31  |         if value.kind_of?(self)
# >>     4    (0.3%) /     4   (0.3%)  |    32  |           return value
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>                                   |    35  |         x = nil
# >>                                   |    36  |         y = nil
# >>                                   |    37  | 
# >>                                   |    38  |         case value
# >>     2    (0.1%) /     2   (0.1%)  |    39  |         when Array
# >>                                   |    40  |           a, b = value
# >>    10    (0.7%)                   |    41  |           x = Position::Hpos.lookup(a)
# >>    21    (1.4%)                   |    42  |           y = Position::Vpos.lookup(b)
# >>     1    (0.1%) /     1   (0.1%)  |    43  |         when String
# >>                                   |    44  |           a, b = value.chars
# >>    14    (1.0%)                   |    45  |           x = Position::Hpos.lookup(a)
# >>    24    (1.6%)                   |    46  |           y = Position::Vpos.lookup(b)
# >>                                   |    47  |         end
# >>                                   |    48  | 
# >>                                   |    49  |         if x && y
# >>     4    (0.3%) /     4   (0.3%)  |    50  |           @memo ||= {}
# >>    21    (1.4%) /     3   (0.2%)  |    51  |           @memo[x] ||= {}
# >>    33    (2.2%) /     5   (0.3%)  |    52  |           @memo[x][y] ||= new(x, y).freeze
# >>                                   |    53  |         end
# >>     2    (0.1%) /     2   (0.1%)  |    54  |       end
# >>                                   |    55  | 
