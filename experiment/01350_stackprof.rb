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
# system "stackprof stackprof.dump --method Warabi::OnePlace::Base.lookup"
# system "stackprof stackprof.dump --method Hash#transform_keys"
# system "stackprof stackprof.dump --method Warabi::Soldier#attributes"

# system "stackprof stackprof.dump --method Warabi::Place.fetch"
# system "stackprof stackprof.dump --method Warabi::Movabler#move_list"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 3266.3 ms
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 799 (0.00% miss rate)
# >>   GC: 159 (19.90%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        159  (19.9%)         159  (19.9%)     (garbage collection)
# >>         88  (11.0%)          86  (10.8%)     Warabi::OnePlace::Base.lookup
# >>         42   (5.3%)          41   (5.1%)     Hash#transform_keys
# >>         35   (4.4%)          35   (4.4%)     block (4 levels) in memory_record
# >>         47   (5.9%)          31   (3.9%)     Warabi::Parser#file_parse
# >>         30   (3.8%)          30   (3.8%)     Warabi::Parser::Base::ConverterMethods#clock_exist?
# >>         29   (3.6%)          29   (3.6%)     Warabi::OnePlace::Base#hash
# >>         30   (3.8%)          27   (3.4%)     Warabi::PieceVector#all_vectors
# >>         23   (2.9%)          23   (2.9%)     Warabi::Soldier#attributes
# >>         17   (2.1%)          17   (2.1%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>         50   (6.3%)          16   (2.0%)     ActiveModel::AttributeAssignment#assign_attributes
# >>        132  (16.5%)          15   (1.9%)     Warabi::Place.lookup
# >>         16   (2.0%)          15   (1.9%)     Warabi::InputParser#scan
# >>         29   (3.6%)          12   (1.5%)     ActiveModel::AttributeAssignment#assign_attributes
# >>         17   (2.1%)          12   (1.5%)     Warabi::Place#hash
# >>        202  (25.3%)          11   (1.4%)     Warabi::Player#candidate_soldiers
# >>         11   (1.4%)          11   (1.4%)     Warabi::Place#to_xy
# >>          9   (1.1%)           9   (1.1%)     #<Module:0x00007fea642efd78>.kconv
# >>          9   (1.1%)           9   (1.1%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>          8   (1.0%)           8   (1.0%)     Warabi::Parser::Base::ConverterMethods#mb_ljust
# >>          7   (0.9%)           7   (0.9%)     Warabi::MediatorBoard#board
# >>          7   (0.9%)           7   (0.9%)     Warabi::OnePlace::Xplace#number_format
# >>          6   (0.8%)           6   (0.8%)     Warabi::OnePlace::Base.units
# >>          5   (0.6%)           5   (0.6%)     Warabi::Piece::VectorMethods#piece_vector
# >>         75   (9.4%)           5   (0.6%)     Set#each
# >>          5   (0.6%)           5   (0.6%)     ActiveModel::AttributeAssignment#_assign_attribute
# >>          4   (0.5%)           4   (0.5%)     ActiveSupport::Duration#initialize
# >>        172  (21.5%)           4   (0.5%)     Warabi::Movabler#move_list
# >>          4   (0.5%)           4   (0.5%)     Warabi::OfficialFormatter#initialize
# >>         13   (1.6%)           4   (0.5%)     Warabi::MoveHand#to_kif
# >> Warabi::Place.lookup (/Users/ikeda/src/warabi/lib/warabi/place.rb:30)
# >>   samples:    15 self (1.9%)  /    132 total (16.5%)
# >>   callers:
# >>       76  (   57.6%)  Warabi::Place.fetch
# >>       56  (   42.4%)  Warabi::Place.[]
# >>   callees (117 total):
# >>       45  (   38.5%)  Warabi::OnePlace::Yplace.lookup
# >>       43  (   36.8%)  Warabi::OnePlace::Xplace.lookup
# >>       29  (   24.8%)  Warabi::OnePlace::Base#hash
# >>   code:
# >>                                   |    30  |       def lookup(value)
# >>     4    (0.5%) /     4   (0.5%)  |    31  |         if value.kind_of?(self)
# >>     1    (0.1%) /     1   (0.1%)  |    32  |           return value
# >>                                   |    33  |         end
# >>                                   |    34  | 
# >>                                   |    35  |         x = nil
# >>                                   |    36  |         y = nil
# >>                                   |    37  | 
# >>                                   |    38  |         case value
# >>     1    (0.1%) /     1   (0.1%)  |    39  |         when Array
# >>                                   |    40  |           a, b = value
# >>     5    (0.6%)                   |    41  |           x = OnePlace::Yplace.lookup(a)
# >>     3    (0.4%)                   |    42  |           y = OnePlace::Xplace.lookup(b)
# >>     1    (0.1%) /     1   (0.1%)  |    43  |         when String
# >>                                   |    44  |           a, b = value.chars
# >>    40    (5.0%)                   |    45  |           x = OnePlace::Yplace.lookup(a)
# >>    40    (5.0%)                   |    46  |           y = OnePlace::Xplace.lookup(b)
# >>                                   |    47  |         end
# >>                                   |    48  | 
# >>                                   |    49  |         if x && y
# >>     3    (0.4%) /     3   (0.4%)  |    50  |           @memo ||= {}
# >>    14    (1.8%) /     3   (0.4%)  |    51  |           @memo[x] ||= {}
# >>    20    (2.5%) /     2   (0.3%)  |    52  |           @memo[x][y] ||= new(x, y).freeze
# >>                                   |    53  |         end
