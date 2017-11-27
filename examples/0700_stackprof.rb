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
# >>   Samples: 217 (0.00% miss rate)
# >>   GC: 28 (12.90%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>         64  (29.5%)          28  (12.9%)     Bushido::Parser::Ki2Parser#parse
# >>         28  (12.9%)          17   (7.8%)     Bushido::Movabler#piece_store
# >>         13   (6.0%)          12   (5.5%)     ActiveSupport::Duration::Scalar#-
# >>         10   (4.6%)           8   (3.7%)     Bushido::Position::Base.units
# >>         33  (15.2%)           7   (3.2%)     Set#each
# >>          7   (3.2%)           7   (3.2%)     Bushido::Position::Hpos#number_format
# >>         22  (10.1%)           7   (3.2%)     Bushido::Point.parse
# >>         10   (4.6%)           6   (2.8%)     Hash#transform_keys
# >>          6   (2.8%)           6   (2.8%)     Bushido::HandLog::OfficialFormatter#initialize
# >>         13   (6.0%)           6   (2.8%)     Bushido::Position::Base.parse
# >>          6   (2.8%)           6   (2.8%)     Bushido::Position::Base#initialize
# >>          5   (2.3%)           5   (2.3%)     block (4 levels) in memory_record
# >>          5   (2.3%)           5   (2.3%)     Bushido::Soldier#to_mini_soldier
# >>         37  (17.1%)           5   (2.3%)     Bushido::Parser#parse_file
# >>          8   (3.7%)           4   (1.8%)     Bushido::Parser::Base::ConverterMethods#clock_exist?
# >>         12   (5.5%)           3   (1.4%)     Bushido::Board::ReaderMethods#lookup
# >>          7   (3.2%)           3   (1.4%)     Bushido::HandLog#to_s_kif
# >>          3   (1.4%)           3   (1.4%)     Bushido::Position::Vpos#number_format
# >>          6   (2.8%)           3   (1.4%)     Bushido::Runner#point_same?
# >>          6   (2.8%)           3   (1.4%)     Bushido::HandLog#initialize
# >>         19   (8.8%)           3   (1.4%)     Bushido::Player#put_on_with_valid
# >>         15   (6.9%)           3   (1.4%)     Bushido::Player::SoldierMethods#soldiers_create_from_mini_soldier
# >>          3   (1.4%)           3   (1.4%)     Bushido::Point#to_xy
# >>          6   (2.8%)           3   (1.4%)     Bushido::Utils#location_mini_soldiers
# >>          7   (3.2%)           2   (0.9%)     Bushido::Point#name
# >>          3   (1.4%)           2   (0.9%)     #<Module:0x007fa07e3de2a0>#promoted_fetch
# >>          2   (0.9%)           2   (0.9%)     block (4 levels) in class_attribute
# >>          2   (0.9%)           2   (0.9%)     Bushido::Player#board
# >>          2   (0.9%)           2   (0.9%)     ActiveSupport::Duration#initialize
# >>          4   (1.8%)           2   (0.9%)     Hash#assert_valid_keys
