require "#{__dir__}/setup"

# Bioshogi.config[:analysis_feature] = false

require "stackprof"

# StackProf.run(mode: :object, out: "stackprof.dump", raw: true) do
# StackProf.run(mode: :wall, out: "stackprof.dump", raw: true) do

ms = Benchmark.ms do
  StackProf.run(mode: :cpu, out: "stackprof.dump", raw: true) do
    20.times do
      ["csa", "ki2", "kif", "sfen"].each do |e|
        info = Parser.file_parse("katomomo.#{e}")
        # info.to_ki2
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
system "stackprof stackprof.dump --method Bioshogi::Analyzer#execute"
# system "stackprof stackprof.dump --method Bioshogi::Dimension::Base.lookup"
# system "stackprof stackprof.dump --method Hash#transform_keys"
# system "stackprof stackprof.dump --method Bioshogi::Soldier#attributes"

# system "stackprof stackprof.dump --method Bioshogi::Place.fetch"
# system "stackprof stackprof.dump --method Bioshogi::SoldierWalker.call"
# system "stackprof --flamegraph stackprof.dump > flamegraph"
# system "stackprof --flamegraph-viewer=flamegraph"
