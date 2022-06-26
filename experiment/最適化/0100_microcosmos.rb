require "../setup"

block = -> { Parser.file_parse("../microcosmos.kif").to_bod }

# require "stackprof"
StackProf.run(mode: :object, out: "/tmp/stackprof-cpu.dump", &block)
# StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
# StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
# StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do

# GC.start
# GC.disable
# GC.enable
# assert { ms < 1130 }

Benchmark.ms(&block)            # => 790.3350000269711

puts `stackprof /tmp/stackprof-cpu.dump`
# >> ==================================
# >>   Mode: object(1)
# >>   Samples: 1068320 (0.00% miss rate)
# >>   GC: 0 (0.00%)
# >> ==================================
# >>      TOTAL    (pct)     SAMPLES    (pct)     FRAME
# >>      76408   (7.2%)       76408   (7.2%)     String#scan
# >>      69202   (6.5%)       69198   (6.5%)     Bioshogi::SimpleModel#initialize
# >>      69201   (6.5%)       69196   (6.5%)     Bioshogi.assert
# >>     281244  (26.3%)       68311   (6.4%)     Class#new
# >>      63827   (6.0%)       63825   (6.0%)     #<Module:0x000000010d11d858>#<=>
# >>      49239   (4.6%)       49239   (4.6%)     String#[]
# >>      43778   (4.1%)       43775   (4.1%)     Bioshogi::SimpleModel#initialize
# >>     284373  (26.6%)       39866   (3.7%)     Bioshogi::Movabler#piece_store
# >>      38772   (3.6%)       38772   (3.6%)     MatchData#named_captures
# >>      33754   (3.2%)       33754   (3.2%)     #<Class:0x0000000109883420>.proc
# >>      27259   (2.6%)       27203   (2.5%)     Bioshogi::Place#vector_add
# >>     399101  (37.4%)       24810   (2.3%)     Bioshogi::Movabler#move_list
# >>      62408   (5.8%)       23896   (2.2%)     Bioshogi::SkillMonitor#execute_one
# >>      21480   (2.0%)       21480   (2.0%)     Hash#merge
# >>      19094   (1.8%)       19094   (1.8%)     Bioshogi::Soldier#attributes
# >>      17924   (1.7%)       17924   (1.7%)     Regexp#match
# >>      17861   (1.7%)       17821   (1.7%)     Array#join
# >>     199910  (18.7%)       17434   (1.6%)     Bioshogi::BoardParser::KakinokiBoardParser#cell_walker
# >>     428913  (40.1%)       16150   (1.5%)     Enumerator::Generator#each
# >>      16149   (1.5%)       16149   (1.5%)     Enumerator#initialize
# >>      72969   (6.8%)       14598   (1.4%)     Bioshogi::HandShared::ClassMethods#create
# >>     172786  (16.2%)       13294   (1.2%)     Bioshogi::Soldier#merge
# >>      12729   (1.2%)       12729   (1.2%)     MatchData#[]
# >>     437590  (41.0%)       12193   (1.1%)     Enumerable#any?
# >>      18262   (1.7%)       11893   (1.1%)     Bioshogi::Piece#all_vectors
# >>      30153   (2.8%)       11891   (1.1%)     Bioshogi::Soldier#all_vectors
# >>      10683   (1.0%)       10676   (1.0%)     Bioshogi::SimpleModel#initialize
# >>     308836  (28.9%)        9857   (0.9%)     Set#each
# >>       9549   (0.9%)        9549   (0.9%)     String#gsub
# >>       6834   (0.6%)        6811   (0.6%)     Bioshogi::DefenseInfo::AttackInfoSharedMethods#tactic_info
