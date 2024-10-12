# -*- compile-command: "rake t" -*-

module Bioshogi
  module Explain
    class TacticStat
      def call
        Dir.chdir(Bioshogi::ROOT.parent) do
          system "rg -g '*.kif' '戦法：.*,' lib/bioshogi/explain > A→B→C戦法.txt"
          system "rg -g '*.kif' '囲い：.*,' lib/bioshogi/explain > A→B→C囲い.txt"
        end
      end
    end
  end
end
