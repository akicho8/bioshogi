require "./example_helper"

# Warabi.config[:skill_set_flag] = false

require "stackprof"

ms = Benchmark.ms do
  # StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
  StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
    1.times do
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
system "stackprof stackprof.dump --method Warabi::Point.lookup"

# system "stackprof stackprof.dump --method Warabi::PlayerExecutor#hand_log"
# system "stackprof stackprof.dump --method Warabi::InputAdapter::Ki2Adapter#candidate_soldiers_select"
# system "stackprof stackprof.dump --method Warabi::SkillMonitor#execute"
# system "stackprof stackprof.dump --method Warabi::Position::Base.lookup"
# system "stackprof stackprof.dump --method Hash#transform_keys"
# system "stackprof stackprof.dump --method Warabi::Soldier#attributes"

# system "stackprof stackprof.dump --method Warabi::Point.fetch"
# system "stackprof stackprof.dump --method Warabi::Movabler#move_list"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 9428.5 ms
# >> ==================================
# >>   Mode: object(1)
# >>   Samples: 730763 (0.00% miss rate)
# >>   GC: 0 (0.00%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>     162873  (22.3%)       67814   (9.3%)     Warabi::Point.lookup
# >>     227986  (31.2%)       65744   (9.0%)     Warabi::BoardParser::KifBoardParser#cell_walker
# >>      54305   (7.4%)       54248   (7.4%)     Warabi::Position::Hpos.lookup
# >>      45024   (6.2%)       45024   (6.2%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>      40702   (5.6%)       40702   (5.6%)     Hash#transform_keys
# >>      40753   (5.6%)       40686   (5.6%)     Warabi::Position::Vpos.lookup
# >>      26689   (3.7%)       26689   (3.7%)     Warabi::Point#to_xy
# >>     166690  (22.8%)       21218   (2.9%)     Warabi::Player#candidate_soldiers
# >>      82404  (11.3%)       20604   (2.8%)     Warabi::PlayerExecutor#input
# >>      17068   (2.3%)       16910   (2.3%)     Warabi::InputParser#scan
# >>      90053  (12.3%)       16884   (2.3%)     Warabi::Soldier.create
# >>      29150   (4.0%)       14340   (2.0%)     Warabi::Soldier#all_vectors
# >>      11776   (1.6%)       11776   (1.6%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>      62695   (8.6%)       10605   (1.5%)     Warabi::Movabler#store_if_alive
# >>      14810   (2.0%)        9561   (1.3%)     Warabi::Piece#all_vectors
# >>       9513   (1.3%)        9513   (1.3%)     ActiveSupport::Duration::Scalar#-
# >>      67203   (9.2%)        9120   (1.2%)     Set#each
# >>     143663  (19.7%)        9066   (1.2%)     Warabi::Movabler#move_list
# >>       9656   (1.3%)        8204   (1.1%)     Warabi::Location.lookup
# >>      51040   (7.0%)        7656   (1.0%)     Warabi::Soldier#merge
# >>      35282   (4.8%)        7512   (1.0%)     Warabi::SkillMonitor#execute_one
# >>       8120   (1.1%)        7105   (1.0%)     Warabi::InputAdapter::UsiAdapter#alpha_to_digit
# >>       7020   (1.0%)        7020   (1.0%)     Warabi::Soldier#attributes
# >>       6805   (0.9%)        6532   (0.9%)     Warabi::SkillSet::List#normalize
# >>       6550   (0.9%)        6520   (0.9%)     Warabi::Point#vector_add
# >>      30354   (4.2%)        5438   (0.7%)     Warabi::Parser::ChessClock::SingleClock#to_s
# >>       6795   (0.9%)        5436   (0.7%)     ActiveSupport::Duration#*
# >>       5424   (0.7%)        5424   (0.7%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>      28326   (3.9%)        4970   (0.7%)     Warabi::BoardParser::KifBoardParser#soldier_create
# >>       5231   (0.7%)        4831   (0.7%)     Warabi::PieceVector#all_vectors
# >> Warabi::Point.lookup (/Users/ikeda/src/warabi/lib/warabi/point.rb:32)
# >>   samples:  67814 self (9.3%)  /   162873 total (22.3%)
# >>   callers:
# >>     128591  (   79.0%)  Warabi::Point.[]
# >>     34282  (   21.0%)  Warabi::Point.fetch
# >>   callees (95059 total):
# >>     54305  (   57.1%)  Warabi::Position::Hpos.lookup
# >>     40753  (   42.9%)  Warabi::Position::Vpos.lookup
# >>        1  (    0.0%)  Warabi::Position::Base#hash
# >>   code:
# >>                                   |    32  |       def lookup(value)
# >>                                   |    33  |         if value.kind_of?(self)
# >>                                   |    34  |           return value
# >>                                   |    35  |         end
# >>                                   |    36  | 
# >>                                   |    37  |         x = nil
# >>                                   |    38  |         y = nil
# >>                                   |    39  | 
# >>                                   |    40  |         case value
# >>                                   |    41  |         when Array
# >>                                   |    42  |           a, b = value
# >>     2    (0.0%)                   |    43  |           x = Position::Hpos.lookup(a)
# >>     8    (0.0%)                   |    44  |           y = Position::Vpos.lookup(b)
# >>                                   |    45  |         when String
# >>  40572    (5.6%) /  40572   (5.6%)  |    46  |           if md = value.match(/\A(?<x>.)(?<y>.)\z/)
# >>  67865    (9.3%) /  13562   (1.9%)  |    47  |             x = Position::Hpos.lookup(md[:x])
# >>  54307    (7.4%) /  13562   (1.9%)  |    48  |             y = Position::Vpos.lookup(md[:y])
# >>                                   |    49  |           end
# >>                                   |    50  |         end
# >>                                   |    51  | 
# >>                                   |    52  |         if x && y
# >>     1    (0.0%) /     1   (0.0%)  |    53  |           @memo ||= {}
# >>    13    (0.0%) /    12   (0.0%)  |    54  |           @memo[x] ||= {}
# >>   105    (0.0%) /   105   (0.0%)  |    55  |           @memo[x][y] ||= new(x, y).freeze
# >>                                   |    56  |         end
