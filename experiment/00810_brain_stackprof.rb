require "./setup"

# xcontainer = Xcontainer.start
# xcontainer.execute("▲６八銀")
# xcontainer.instance_variables     # => [:@board, :@turn_info, :@players, :@initial_state_board_sfen, :@variables, :@var_stack, :@params, :@hand_logs]
# 
# xcontainer = XcontainerSimple.start
# xcontainer.execute("▲６八銀")
# xcontainer.instance_variables     # => 

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

xcontainer = Xcontainer.start

StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do
  50.times do
    v, pv = xcontainer.current_player.brain.diver_dive(depth_max: 2)
    hand = pv.first
    xcontainer.execute(hand.to_sfen, executor_class: PlayerExecutorWithoutMonitor)
  end
end
puts xcontainer
tp Bioshogi.run_counts

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Bioshogi::Place.lookup"

# >> 後手の持駒：歩三
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・v金 ・v金 ・v桂 ・|一
# >> | ・v飛 ・v銀 ・ ・v銀 ・v香|二
# >> |v香 ・v桂v歩 ・v歩 ・v歩v歩|三
# >> |v歩 歩 玉v馬v歩 ・v歩v玉 ・|四
# >> | ・ ・ 歩 ・ ・ ・ ・ 桂 ・|五
# >> | 歩 ・ ・ ・ ・ ・ 歩 歩 歩|六
# >> | 角 ・ ・ 歩 ・ ・ ・ ・ 香|七
# >> | 香 ・ ・ ・ ・ ・ 飛 ・ ・|八
# >> | ・ 桂 銀 金 ・ 金 銀 ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：歩
# >> 手数＝50 △６四馬(19) まで
# >> 
# >> 先手番
# >> |-----------------------------+-------|
# >> |     Bioshogi::MoveHand.create | 21973 |
# >> |     sandbox_execute.execute | 38626 |
# >> |      sandbox_execute.revert | 38626 |
# >> | Bioshogi::Evaluator::Base#score | 16796 |
# >> |     Bioshogi::DropHand.create | 550   |
# >> |-----------------------------+-------|
# >> ==================================
# >>   Mode: wall(1000)
# >>   Samples: 13357 (0.00% miss rate)
# >>   GC: 1882 (14.09%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>       1896  (14.2%)        1896  (14.2%)     Bioshogi::Dimension::Base#hash
# >>       1882  (14.1%)        1882  (14.1%)     (garbage collection)
# >>      11384  (85.2%)        1168   (8.7%)     Bioshogi::Movabler#move_list
# >>       4246  (31.8%)        1058   (7.9%)     Bioshogi::Place.lookup
# >>        946   (7.1%)         946   (7.1%)     Bioshogi::Dimension::Base.lookup
# >>        819   (6.1%)         741   (5.5%)     Bioshogi::PieceVector#all_vectors
# >>       1141   (8.5%)         652   (4.9%)     Bioshogi::Place#hash
# >>        621   (4.6%)         621   (4.6%)     block (3 levels) in memory_record
# >>        544   (4.1%)         544   (4.1%)     Bioshogi::Dimension::Base.value_range
# >>        489   (3.7%)         489   (3.7%)     Bioshogi::Place#to_xy
# >>      11391  (85.3%)         428   (3.2%)     Bioshogi::Player::BrainMethods#move_hands
# >>        863   (6.5%)         319   (2.4%)     Bioshogi::Dimension::Base#valid?
# >>        310   (2.3%)         310   (2.3%)     Bioshogi::Piece::VectorMethods#piece_vector
# >>        216   (1.6%)         216   (1.6%)     Bioshogi::XcontainerBase#board
# >>        674   (5.0%)         188   (1.4%)     Bioshogi::Dimension::Xplace.lookup
# >>        629   (4.7%)         169   (1.3%)     Bioshogi::Dimension::Yplace.lookup
# >>        168   (1.3%)         168   (1.3%)     Bioshogi::Piece::ScoreMethods#piece_score
# >>        455   (3.4%)         145   (1.1%)     #<Module:0x00007ffcd2539d60>#<=>
# >>        140   (1.0%)         140   (1.0%)     Bioshogi::Board#surface
# >>        131   (1.0%)         131   (1.0%)     Bioshogi::SimpleModel#initialize
# >>      10705  (80.1%)         105   (0.8%)     Set#each
# >>        529   (4.0%)         101   (0.8%)     Bioshogi::Player::SoldierMethods#soldiers
# >>      11279  (84.4%)          95   (0.7%)     Bioshogi::Movabler#piece_store
# >>        177   (1.3%)          91   (0.7%)     Bioshogi::Board::UpdateMethods#place_on
# >>         81   (0.6%)          81   (0.6%)     Bioshogi::SimpleModel#initialize
# >>         64   (0.5%)          44   (0.3%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>         40   (0.3%)          40   (0.3%)     #<Module:0x00007ffcd23ba188>.run_counts
# >>         67   (0.5%)          36   (0.3%)     Bioshogi::Player::BrainMethods#evaluator
# >>         99   (0.7%)          36   (0.3%)     Bioshogi::PieceScore#any_weight
# >>         31   (0.2%)          31   (0.2%)     Bioshogi::Evaluator::Base#initialize
# >> Bioshogi::Place.lookup (/Users/ikeda/src/bioshogi/lib/bioshogi/place.rb:30)
# >>   samples:  1058 self (7.9%)  /   4246 total (31.8%)
# >>   callers:
# >>     4215  (   99.3%)  Bioshogi::Place.fetch
# >>       31  (    0.7%)  Bioshogi::Place.[]
# >>   callees (3188 total):
# >>     1896  (   59.5%)  Bioshogi::Dimension::Base#hash
# >>      674  (   21.1%)  Bioshogi::Dimension::Xplace.lookup
# >>      618  (   19.4%)  Bioshogi::Dimension::Yplace.lookup
# >>   code:
# >>                                   |    30  |       def lookup(value)
# >>   676    (5.1%) /   676   (5.1%)  |    31  |         if value.kind_of?(self)
# >>                                   |    32  |           return value
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>                                   |    35  |         x = nil
# >>                                   |    36  |         y = nil
# >>                                   |    37  | 
# >>                                   |    38  |         case value
# >>    73    (0.5%) /    73   (0.5%)  |    39  |         when Array
# >>                                   |    40  |           a, b = value
# >>   673    (5.0%)                   |    41  |           x = Dimension::Xplace.lookup(a)
# >>   618    (4.6%)                   |    42  |           y = Dimension::Yplace.lookup(b)
# >>                                   |    43  |         when String
# >>                                   |    44  |           a, b = value.chars
# >>     1    (0.0%)                   |    45  |           x = Dimension::Xplace.lookup(a)
# >>                                   |    46  |           y = Dimension::Yplace.lookup(b)
# >>    10    (0.1%) /    10   (0.1%)  |    47  |         end
# >>                                   |    48  | 
# >>                                   |    49  |         if x && y
# >>    76    (0.6%) /    76   (0.6%)  |    50  |           @memo ||= {}
# >>   777    (5.8%) /   104   (0.8%)  |    51  |           @memo[x] ||= {}
# >>  1324    (9.9%) /   101   (0.8%)  |    52  |           @memo[x][y] ||= new(x, y).freeze
# >>                                   |    53  |         end
# >>    18    (0.1%) /    18   (0.1%)  |    54  |       end
# >>                                   |    55  | 
