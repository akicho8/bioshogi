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
# >>   Samples: 15992 (0.00% miss rate)
# >>   GC: 3028 (18.93%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>       1590   (9.9%)        1356   (8.5%)     Bushido::Position::Base.parse
# >>        989   (6.2%)         989   (6.2%)     block (4 levels) in memory_record
# >>       3144  (19.7%)         773   (4.8%)     Bushido::Point.parse
# >>       1400   (8.8%)         548   (3.4%)     Bushido::Board::ReaderMethods#lookup
# >>       1978  (12.4%)         533   (3.3%)     Bushido::Movabler#piece_store
# >>      11839  (74.0%)         406   (2.5%)     Bushido::Runner#execute
# >>        393   (2.5%)         393   (2.5%)     Bushido::Point#to_xy
# >>        351   (2.2%)         351   (2.2%)     #<Module:0x007fcd5e8485b8>.kconv
# >>        312   (2.0%)         312   (2.0%)     Bushido::Position::Base.value_range
# >>       2340  (14.6%)         281   (1.8%)     Set#each
# >>        273   (1.7%)         273   (1.7%)     Bushido::Point#initialize
# >>        502   (3.1%)         254   (1.6%)     Bushido::HandLog#initialize
# >>        493   (3.1%)         239   (1.5%)     Hash#transform_keys
# >>       1099   (6.9%)         230   (1.4%)     Bushido::Position::Hpos.parse
# >>        230   (1.4%)         230   (1.4%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>        229   (1.4%)         229   (1.4%)     Bushido::Soldier#to_mini_soldier
# >>        217   (1.4%)         217   (1.4%)     ActiveSupport::Duration#initialize
# >>      10360  (64.8%)         184   (1.2%)     Bushido::Movabler#movable_infos
# >>        230   (1.4%)         180   (1.1%)     Bushido::Position::Vpos#number_format
# >>        301   (1.9%)         179   (1.1%)     Bushido::Parser#source_normalize
# >>        657   (4.1%)         177   (1.1%)     Bushido::Parser::Base::ConverterMethods#clock_exist?
# >>        204   (1.3%)         174   (1.1%)     Bushido::Position::Hpos#number_format
# >>        174   (1.1%)         174   (1.1%)     Bushido::Vector#reverse_sign
# >>        242   (1.5%)         171   (1.1%)     ActiveSupport::Duration::Scalar#-
# >>        166   (1.0%)         166   (1.0%)     ActiveSupport::Duration#to_i
# >>        478   (3.0%)         166   (1.0%)     Bushido::Position::Base#valid?
# >>        261   (1.6%)         156   (1.0%)     Bushido::Piece::NameMethods#basic_names
# >>        920   (5.8%)         147   (0.9%)     Bushido::Position::Vpos.parse
# >>        134   (0.8%)         134   (0.8%)     Numeric#blank?
# >>        206   (1.3%)         126   (0.8%)     ActiveSupport::Duration.===
# >> Bushido::Position::Base.parse (/Users/ikeda/src/bushido/lib/bushido/position.rb:69)
# >>   samples:  1356 self (8.5%)  /   1590 total (9.9%)
# >>   callers:
# >>      869  (   54.7%)  Bushido::Position::Hpos.parse
# >>      721  (   45.3%)  Bushido::Position::Vpos.parse
# >>   callees (234 total):
# >>      134  (   57.3%)  Numeric#blank?
# >>       56  (   23.9%)  String#blank?
# >>       44  (   18.8%)  Bushido::Position::Base.units_set
# >>   code:
# >>                                   |    69  |         def parse(arg)
# >>   769    (4.8%) /   769   (4.8%)  |    70  |           if arg.kind_of?(Base)
# >>    40    (0.3%) /    40   (0.3%)  |    71  |             return arg
# >>                                   |    72  |           end
# >>                                   |    73  | 
# >>   198    (1.2%) /     8   (0.1%)  |    74  |           if arg.blank?
# >>                                   |    75  |             raise PositionSyntaxError, "引数がありません"
# >>                                   |    76  |           end
# >>                                   |    77  | 
# >>   109    (0.7%) /   109   (0.7%)  |    78  |           if arg.kind_of?(String)
# >>    44    (0.3%)                   |    79  |             v = units_set[arg]
# >>    23    (0.1%) /    23   (0.1%)  |    80  |             v or raise PositionSyntaxError, "#{arg.inspect} が #{units} の中にありません"
# >>                                   |    81  |           else
# >>                                   |    82  |             v = arg
# >>                                   |    83  |           end
# >>                                   |    84  | 
# >>   169    (1.1%) /   169   (1.1%)  |    85  |           @instance ||= {}
# >>   238    (1.5%) /   238   (1.5%)  |    86  |           @instance[v] ||= new(v)
# >>                                   |    87  |         end
