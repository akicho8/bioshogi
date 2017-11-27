require "./example_helper"

require "stackprof"

StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do
  100.times do
    ["csa", "ki2", "kif"].each do |e|
      info = Parser.parse_file("katomomo.#{e}")
      info.to_ki2
      info.to_kif
      info.to_csa
    end
  end
end

system "stackprof stackprof.dump"
system "stackprof stackprof.dump --method Bushido::Position::Base.parse"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"

# >> ==================================
# >>   Mode: wall(1000)
# >>   Samples: 16243 (0.00% miss rate)
# >>   GC: 3109 (19.14%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>       1573   (9.7%)        1365   (8.4%)     Bushido::Position::Base.parse
# >>       1041   (6.4%)        1041   (6.4%)     block (4 levels) in memory_record
# >>       3161  (19.5%)         775   (4.8%)     Bushido::Point.parse
# >>       1514   (9.3%)         596   (3.7%)     Bushido::Board::ReaderMethods#lookup
# >>       1966  (12.1%)         541   (3.3%)     Bushido::Movabler#piece_store
# >>      12056  (74.2%)         396   (2.4%)     Bushido::Runner#execute
# >>        382   (2.4%)         382   (2.4%)     #<Module:0x007f939c327260>.kconv
# >>        375   (2.3%)         375   (2.3%)     Bushido::Point#to_xy
# >>        309   (1.9%)         309   (1.9%)     Bushido::Position::Base.value_range
# >>        300   (1.8%)         300   (1.8%)     Bushido::Point#initialize
# >>        549   (3.4%)         279   (1.7%)     Bushido::HandLog#initialize
# >>       2365  (14.6%)         257   (1.6%)     Set#each
# >>        525   (3.2%)         242   (1.5%)     Hash#transform_keys
# >>       1043   (6.4%)         232   (1.4%)     Bushido::Position::Hpos.parse
# >>        765   (4.7%)         210   (1.3%)     Bushido::Parser::Base::ConverterMethods#clock_exist?
# >>        210   (1.3%)         210   (1.3%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>        207   (1.3%)         207   (1.3%)     ActiveSupport::Duration#initialize
# >>        203   (1.2%)         203   (1.2%)     Bushido::Soldier#to_mini_soldier
# >>        203   (1.2%)         203   (1.2%)     Bushido::Vector#reverse_sign
# >>        290   (1.8%)         198   (1.2%)     ActiveSupport::Duration::Scalar#-
# >>      10698  (65.9%)         184   (1.1%)     Bushido::Movabler#movable_infos
# >>        180   (1.1%)         180   (1.1%)     ActiveSupport::Duration#to_i
# >>        296   (1.8%)         169   (1.0%)     Bushido::Parser#source_normalize
# >>        466   (2.9%)         157   (1.0%)     Bushido::Position::Base#valid?
# >>        186   (1.1%)         155   (1.0%)     Bushido::Position::Hpos#number_format
# >>        278   (1.7%)         149   (0.9%)     Bushido::Piece::NameMethods#basic_names
# >>        966   (5.9%)         148   (0.9%)     Bushido::Position::Vpos.parse
# >>        197   (1.2%)         145   (0.9%)     Bushido::Position::Vpos#number_format
# >>        284   (1.7%)         143   (0.9%)     Hash#assert_valid_keys
# >>        140   (0.9%)         140   (0.9%)     Bushido::HandLog::OfficialFormatter#initialize
# >> Bushido::Position::Base.parse (/Users/ikeda/src/bushido/lib/bushido/position.rb:69)
# >>   samples:  1365 self (8.4%)  /   1573 total (9.7%)
# >>   callers:
# >>      811  (   51.6%)  Bushido::Position::Hpos.parse
# >>      762  (   48.4%)  Bushido::Position::Vpos.parse
# >>   callees (208 total):
# >>      134  (   64.4%)  Numeric#blank?
# >>       45  (   21.6%)  String#blank?
# >>       29  (   13.9%)  Bushido::Position::Base.units_set
# >>   code:
# >>                                   |    69  |         def parse(arg)
# >>   764    (4.7%) /   764   (4.7%)  |    70  |           if arg.kind_of?(Base)
# >>    37    (0.2%) /    37   (0.2%)  |    71  |             return arg
# >>                                   |    72  |           end
# >>                                   |    73  | 
# >>   184    (1.1%) /     5   (0.0%)  |    74  |           if arg.blank?
# >>                                   |    75  |             raise PositionSyntaxError, "引数がありません"
# >>                                   |    76  |           end
# >>                                   |    77  | 
# >>   116    (0.7%) /   116   (0.7%)  |    78  |           if arg.kind_of?(String)
# >>    29    (0.2%)                   |    79  |             v = units_set[arg]
# >>    16    (0.1%) /    16   (0.1%)  |    80  |             v or raise PositionSyntaxError, "#{arg.inspect} が #{units} の中にありません"
# >>                                   |    81  |           else
# >>                                   |    82  |             v = arg
# >>                                   |    83  |           end
# >>                                   |    84  | 
# >>   189    (1.2%) /   189   (1.2%)  |    85  |           @instance ||= {}
# >>   238    (1.5%) /   238   (1.5%)  |    86  |           @instance[v] ||= new(v)
# >>                                   |    87  |         end
