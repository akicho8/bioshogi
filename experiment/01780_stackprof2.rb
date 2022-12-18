require "./setup"

# Bioshogi.config[:skill_monitor_enable] = false

require "stackprof"

ms = Benchmark.ms do
  # StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
  # StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
  StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do
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
# system "stackprof stackprof.dump --method Bioshogi::Place.lookup"
# system "stackprof stackprof.dump --method Bioshogi::PlayerExecutor::Human#hand_log"
# system "stackprof stackprof.dump --method Bioshogi::InputAdapter::Ki2Adapter#candidate_soldiers_select"
# system "stackprof stackprof.dump --method Bioshogi::SkillMonitor#execute"
# system "stackprof stackprof.dump --method Bioshogi::Dimension::Base.lookup"
system "stackprof stackprof.dump --method Bioshogi::Dimension::Xplace.lookup"
# system "stackprof stackprof.dump --method Hash#transform_keys"
# system "stackprof stackprof.dump --method Bioshogi::Soldier#attributes"

# system "stackprof stackprof.dump --method Bioshogi::Place.fetch"
# system "stackprof stackprof.dump --method Bioshogi::Movabler#move_list"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> 853.5 ms
# >> ==================================
# >>   Mode: wall(1000)
# >>   Samples: 832 (0.24% miss rate)
# >>   GC: 86 (10.34%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        145  (17.4%)         142  (17.1%)     Bioshogi::Dimension::Base.lookup
# >>         86  (10.3%)          86  (10.3%)     (garbage collection)
# >>         52   (6.2%)          52   (6.2%)     block (3 levels) in memory_record
# >>         49   (5.9%)          49   (5.9%)     Bioshogi::Dimension::Base#hash
# >>        256  (30.8%)          44   (5.3%)     Bioshogi::Place.lookup
# >>         43   (5.2%)          43   (5.2%)     Bioshogi::SimpleModel#initialize
# >>         20   (2.4%)          20   (2.4%)     Bioshogi::SimpleModel#initialize
# >>         17   (2.0%)          17   (2.0%)     Bioshogi::BoardParser::KakinokiBoardParser#prefix_char_validate
# >>        275  (33.1%)          17   (2.0%)     Bioshogi::BoardParser::CompareBoardParser#parse
# >>        275  (33.1%)          15   (1.8%)     Bioshogi::BoardParser::KakinokiBoardParser#cell_walker
# >>         15   (1.8%)          15   (1.8%)     Bioshogi::Dimension::Yplace._units
# >>         14   (1.7%)          14   (1.7%)     Bioshogi::Place#to_xy
# >>         12   (1.4%)          12   (1.4%)     Hash#symbolize_keys
# >>         11   (1.3%)          11   (1.3%)     Bioshogi::Parser::Base::ConverterMethods#mb_ljust
# >>         17   (2.0%)          10   (1.2%)     Bioshogi::Place#hash
# >>         17   (2.0%)          10   (1.2%)     Bioshogi::Source.wrap
# >>         10   (1.2%)          10   (1.2%)     Bioshogi::Dimension::Base.units
# >>         11   (1.3%)           9   (1.1%)     Bioshogi::PieceVector#all_vectors
# >>         25   (3.0%)           8   (1.0%)     #<Module:0x00007ff71818ba70>#<=>
# >>          8   (1.0%)           8   (1.0%)     #<Module:0x00007ff71734a998>.kconv
# >>          8   (1.0%)           8   (1.0%)     Bioshogi::Soldier#attributes
# >>         10   (1.2%)           8   (1.0%)     Bioshogi::InputParser#scan
# >>          8   (1.0%)           8   (1.0%)     Bioshogi::Core#board
# >>        136  (16.3%)           7   (0.8%)     Bioshogi::Movabler#move_list
# >>          7   (0.8%)           7   (0.8%)     Bioshogi::Dimension::Base.value_range
# >>         88  (10.6%)           6   (0.7%)     Bioshogi::Dimension::Xplace.lookup
# >>          6   (0.7%)           6   (0.7%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>          5   (0.6%)           5   (0.6%)     Bioshogi::Piece::NameMethods::ClassMethods#all_names
# >>          6   (0.7%)           5   (0.6%)     Bioshogi::Dimension::Xplace#hankaku_number
# >>         12   (1.4%)           5   (0.6%)     Bioshogi::Dimension::Base#valid?
# >> Bioshogi::Dimension::Xplace.lookup (/Users/ikeda/src/bioshogi/lib/bioshogi/dimension.rb:178)
# >>   samples:     6 self (0.7%)  /     88 total (10.6%)
# >>   callers:
# >>       84  (   95.5%)  Bioshogi::Place.lookup
# >>        4  (    4.5%)  Bioshogi::Dimension::Base.fetch
# >>   callees (82 total):
# >>       82  (  100.0%)  Bioshogi::Dimension::Base.lookup
# >>   code:
# >>                                   |   178  |       def self.lookup(value)
# >>     5    (0.6%) /     5   (0.6%)  |   179  |         if value.kind_of?(String)
# >>                                   |   180  |           value = value.tr("1-9一二三四五六七八九", "１-９１-９")
# >>                                   |   181  |         end
# >>    82    (9.9%)                   |   182  |         super
# >>     1    (0.1%) /     1   (0.1%)  |   183  |       end
# >>                                   |   184  | 
