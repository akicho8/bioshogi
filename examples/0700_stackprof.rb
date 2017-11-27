require "./example_helper"

require "stackprof"

StackProf.run(mode: :cpu, out: "stackprof-cpu-myapp.dump") do
  10.times do
    info = Parser.parse_file("katomomo.ki2")
    info.to_ki2
    info.to_kif
    info.to_csa
  end
end

system "stackprof stackprof-cpu-myapp.dump"
# >> ==================================
# >>   Mode: cpu(1000)
# >>   Samples: 279 (0.00% miss rate)
# >>   GC: 42 (15.05%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        261  (93.5%)          66  (23.7%)     Bushido::Movabler#simple_movable_infos
# >>         48  (17.2%)          20   (7.2%)     Bushido::Parser::Ki2Parser#parse
# >>         39  (14.0%)          17   (6.1%)     Bushido::Point.parse
# >>        104  (37.3%)          14   (5.0%)     Bushido::Movabler#piece_store
# >>          9   (3.2%)           9   (3.2%)     block (4 levels) in memory_record
# >>          7   (2.5%)           7   (2.5%)     Bushido::Position::Base#initialize
# >>         33  (11.8%)           7   (2.5%)     Bushido::Parser#parse_file
# >>         14   (5.0%)           7   (2.5%)     Bushido::Position::Base.parse
# >>        115  (41.2%)           7   (2.5%)     Set#each
# >>          9   (3.2%)           6   (2.2%)     Bushido::Position::Base.units
# >>         10   (3.6%)           5   (1.8%)     Bushido::Position::Hpos.parse
# >>          4   (1.4%)           4   (1.4%)     Bushido::Soldier#to_mini_soldier
# >>          7   (2.5%)           4   (1.4%)     Bushido::Board::ReaderMethods#lookup
# >>          4   (1.4%)           4   (1.4%)     Bushido::Position::Hpos#number_format
# >>         22   (7.9%)           4   (1.4%)     Bushido::Player::SoldierMethods#soldiers_create_from_mini_soldier
# >>          6   (2.2%)           3   (1.1%)     Hash#assert_valid_keys
# >>          3   (1.1%)           3   (1.1%)     block (4 levels) in class_attribute
# >>          3   (1.1%)           3   (1.1%)     Bushido::Position::Vpos#number_format
# >>          8   (2.9%)           3   (1.1%)     #<Module:0x007fe24a5aa440>#promoted_fetch
# >>         10   (3.6%)           2   (0.7%)     #<Module:0x007fe24a5aa440>#basic_get
# >>          5   (1.8%)           2   (0.7%)     Bushido::Utils#location_mini_soldiers
# >>          2   (0.7%)           2   (0.7%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>          2   (0.7%)           2   (0.7%)     Bushido::Position::Vpos#_promotable_size
# >>          2   (0.7%)           2   (0.7%)     Bushido::HandLog::OfficialFormatter#initialize
# >>          2   (0.7%)           2   (0.7%)     Bushido::Runner.input_regexp
# >>          2   (0.7%)           2   (0.7%)     Bushido::Point#to_xy
# >>          3   (1.1%)           2   (0.7%)     Bushido::Piece::NameMethods#basic_names
# >>          2   (0.7%)           2   (0.7%)     Bushido::Vector#reverse_sign
# >>          3   (1.1%)           2   (0.7%)     Bushido::Parser#source_normalize
# >>          2   (0.7%)           2   (0.7%)     ActiveSupport::Duration#initialize
