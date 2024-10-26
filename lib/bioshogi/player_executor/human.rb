module Bioshogi
  module PlayerExecutor
    class Human < Base
      include HandLogsMod
      include Analysis::AnalyzerMod
    end
  end
end
