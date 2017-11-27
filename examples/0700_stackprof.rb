require "./example_helper"

require "stackprof"

StackProf.run(mode: :wall, out: "stackprof-cpu-myapp.dump") do
  20.times do
    info = Parser.parse_file("katomomo.ki2")
    info.to_ki2
    info.to_kif
    info.to_csa
  end
end

system "stackprof stackprof-cpu-myapp.dump"
# >> ==================================
# >>   Mode: wall(1000)
# >>   Samples: 2562 (0.00% miss rate)
# >>   GC: 446 (17.41%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>        386  (15.1%)         292  (11.4%)     Bushido::Position::Base.units
# >>       2902 (113.3%)         185   (7.2%)     Bushido::Movabler#simple_movable_infos
# >>        245   (9.6%)         138   (5.4%)     Bushido::Position::Base.parse
# >>        496  (19.4%)         131   (5.1%)     Bushido::Point.parse
# >>        123   (4.8%)         123   (4.8%)     block (4 levels) in memory_record
# >>        100   (3.9%)         100   (3.9%)     Bushido::Position::Base#initialize
# >>         95   (3.7%)          95   (3.7%)     block (4 levels) in class_attribute
# >>        185   (7.2%)          80   (3.1%)     Bushido::Parser::Ki2Parser#parse
# >>        428  (16.7%)          74   (2.9%)     Bushido::Position::Base#valid?
# >>        143   (5.6%)          67   (2.6%)     Bushido::Position::Base#name
# >>        354  (13.8%)          54   (2.1%)     Bushido::Position::Base.value_range
# >>        164   (6.4%)          49   (1.9%)     Bushido::Position::Vpos.parse
# >>        113   (4.4%)          46   (1.8%)     Bushido::Board::ReaderMethods#lookup
# >>        416  (16.2%)          38   (1.5%)     Bushido::Point#name
# >>         37   (1.4%)          37   (1.4%)     Bushido::Point#initialize
# >>       1025  (40.0%)          35   (1.4%)     Bushido::Movabler#piece_store
# >>        477  (18.6%)          35   (1.4%)     Bushido::MiniSoldier#formal_name
# >>         75   (2.9%)          32   (1.2%)     Set#each
# >>         28   (1.1%)          28   (1.1%)     Bushido::Point#to_xy
# >>        162   (6.3%)          28   (1.1%)     Bushido::Position::Hpos.parse
# >>         24   (0.9%)          24   (0.9%)     #<Module:0x007fb0ffb05ee8>.kconv
# >>         45   (1.8%)          22   (0.9%)     Bushido::Piece::NameMethods#some_name
# >>         36   (1.4%)          18   (0.7%)     Bushido::Parser::Base::ConverterMethods#clock_exist?
# >>         17   (0.7%)          17   (0.7%)     ActiveSupport::Duration#initialize
# >>         23   (0.9%)          17   (0.7%)     Bushido::Position::Vpos#number_format
# >>         15   (0.6%)          15   (0.6%)     Bushido::Soldier#to_mini_soldier
# >>         16   (0.6%)          14   (0.5%)     ActiveSupport::Duration.===
# >>       2847 (111.1%)          14   (0.5%)     Bushido::Runner#execute
# >>         14   (0.5%)          14   (0.5%)     MemoryRecord::SingletonMethods::ClassMethods#lookup
# >>         20   (0.8%)          12   (0.5%)     ActiveSupport::Duration::Scalar#-
