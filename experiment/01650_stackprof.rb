require "./example_helper"

# Warabi.config[:skill_monitor_enable] = false

require "stackprof"

ms = Benchmark.ms do
  StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
  # StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
    # StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do
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
system "stackprof stackprof.dump --method Warabi::Place.lookup"

# system "stackprof stackprof.dump --method Warabi::PlayerExecutorHuman#hand_log"
# system "stackprof stackprof.dump --method Warabi::InputAdapter::Ki2Adapter#candidate_soldiers_select"
# system "stackprof stackprof.dump --method Warabi::SkillMonitor#execute"
# system "stackprof stackprof.dump --method Warabi::Dimension::Base.lookup"
# system "stackprof stackprof.dump --method Hash#transform_keys"
# system "stackprof stackprof.dump --method Warabi::Soldier#attributes"

# system "stackprof stackprof.dump --method Warabi::Place.fetch"
# system "stackprof stackprof.dump --method Warabi::Movabler#move_list"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 3029.9 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 745 (0.00% miss rate)
# >>   GC: 129 (17.32%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        129  (17.3%)         129  (17.3%)     (garbage collection)
# >>         85  (11.4%)          83  (11.1%)     Warabi::Dimension::Base.lookup
# >>         51   (6.8%)          51   (6.8%)     block (3 levels) in memory_record
# >>         45   (6.0%)          45   (6.0%)     Warabi::SimpleModel#initialize
# >>         49   (6.6%)          34   (4.6%)     Warabi::Parser#file_parse
# >>        147  (19.7%)          29   (3.9%)     Warabi::Place.lookup
# >>         28   (3.8%)          28   (3.8%)     Warabi::Dimension::Base#hash
# >>         17   (2.3%)          16   (2.1%)     Warabi::InputParser#scan
# >>         16   (2.1%)          16   (2.1%)     Warabi::Place#to_xy
# >>         15   (2.0%)          15   (2.0%)     Warabi::Dimension::Xplace#number_format
# >>         15   (2.0%)          15   (2.0%)     Hash#symbolize_keys
# >>         15   (2.0%)          14   (1.9%)     Warabi::PieceVector#all_vectors
# >>         14   (1.9%)          14   (1.9%)     Warabi::Soldier#attributes
# >>         13   (1.7%)          13   (1.7%)     Warabi::SimpleModel#initialize
# >>         13   (1.7%)          13   (1.7%)     ActiveSupport::Duration#initialize
# >>        169  (22.7%)          10   (1.3%)     Warabi::Player#candidate_soldiers
# >>          9   (1.2%)           9   (1.2%)     #<Module:0x00007ff8a51ca4f8>.kconv
# >>          9   (1.2%)           9   (1.2%)     Warabi::Parser::Base::ConverterMethods#mb_ljust
# >>          7   (0.9%)           7   (0.9%)     Warabi::SimpleModel#initialize
# >>        137  (18.4%)           7   (0.9%)     Warabi::Movabler#move_list
# >>          7   (0.9%)           7   (0.9%)     Warabi::OfficialFormatter#initialize
# >>          7   (0.9%)           7   (0.9%)     Warabi::Dimension::Base.value_range
# >>          6   (0.8%)           6   (0.8%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>          5   (0.7%)           5   (0.7%)     #<Module:0x00007ff8a4b27330>.run_counts
# >>         43   (5.8%)           5   (0.7%)     Warabi::Dimension::Yplace.lookup
# >>          5   (0.7%)           5   (0.7%)     Warabi::Dimension::Base.units
# >>          4   (0.5%)           4   (0.5%)     ActiveSupport::Duration#respond_to_missing?
# >>          4   (0.5%)           4   (0.5%)     Warabi::Piece::VectorMethods#piece_vector
# >>          5   (0.7%)           4   (0.5%)     MemoryRecord::SingletonMethods::ClassMethods#fetch
# >>          4   (0.5%)           4   (0.5%)     Warabi::MediatorBase#board
# >> Warabi::Place.lookup (/Users/ikeda/src/warabi/lib/warabi/place.rb:30)
# >>   samples:    29 self (3.9%)  /    147 total (19.7%)
# >>   callers:
# >>      103  (   70.1%)  Warabi::Place.fetch
# >>       44  (   29.9%)  Warabi::Place.[]
# >>   callees (118 total):
# >>       49  (   41.5%)  Warabi::Dimension::Xplace.lookup
# >>       41  (   34.7%)  Warabi::Dimension::Yplace.lookup
# >>       28  (   23.7%)  Warabi::Dimension::Base#hash
# >>   code:
# >>                                   |    30  |       def lookup(value)
# >>    21    (2.8%) /    21   (2.8%)  |    31  |         if value.kind_of?(self)
# >>     1    (0.1%) /     1   (0.1%)  |    32  |           return value
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>                                   |    35  |         x = nil
# >>                                   |    36  |         y = nil
# >>                                   |    37  | 
# >>                                   |    38  |         case value
# >>     2    (0.3%) /     2   (0.3%)  |    39  |         when Array
# >>                                   |    40  |           a, b = value
# >>     2    (0.3%)                   |    41  |           x = Dimension::Xplace.lookup(a)
# >>     8    (1.1%)                   |    42  |           y = Dimension::Yplace.lookup(b)
# >>     1    (0.1%) /     1   (0.1%)  |    43  |         when String
# >>                                   |    44  |           a, b = value.chars
# >>    47    (6.3%)                   |    45  |           x = Dimension::Xplace.lookup(a)
# >>    33    (4.4%)                   |    46  |           y = Dimension::Yplace.lookup(b)
# >>                                   |    47  |         end
# >>                                   |    48  | 
# >>                                   |    49  |         if x && y
# >>                                   |    50  |           @memo ||= {}
# >>    13    (1.7%) /     2   (0.3%)  |    51  |           @memo[x] ||= {}
# >>    18    (2.4%) /     1   (0.1%)  |    52  |           @memo[x][y] ||= new(x, y).freeze
# >>                                   |    53  |         end
# >>     1    (0.1%) /     1   (0.1%)  |    54  |       end
# >>                                   |    55  | 
