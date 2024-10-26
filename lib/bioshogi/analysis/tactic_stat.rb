# -*- compile-command: "rake t" -*-

module Bioshogi
  module Analysis
    class TacticStat
      def call
        Dir.chdir(Bioshogi::ROOT.parent) do
          system "rg --sort path -g '*.kif' '戦法：.*,' lib/bioshogi/analysis > A→B→C戦法.txt"
          system "rg --sort path -g '*.kif' '囲い：.*,' lib/bioshogi/analysis > A→B→C囲い.txt"
        end
      end
    end
  end
end
