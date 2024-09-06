require "spec_helper"

module Bioshogi
  module Explain
    describe TacticInfo do
      describe "すべての戦法の判定", tactic: true do
        TacticInfo.all_elements.each do |e|
          it e.key do
            file = e.sample_kif_or_ki2_file
            info = Parser.parse(file)
            info.formatter.container_run_once
            if ["居玉", "力戦", "相居玉", "背水の陣", "相居飛車", "対振り飛車", "相振り飛車", "対抗形"].include?(e.key.to_s)
              next
            end
            assert { info.formatter.container.normalized_names_with_alias.include?(e.key.to_s) }
          end
        end
      end

      describe "flat_lookup" do
        it "works" do
          assert { TacticInfo.flat_lookup("金底の歩") }
        end
        it "文字列でなくても to_s してから探す" do
          o = Object.new
          def o.to_s; "金底の歩"; end
          assert { TacticInfo.flat_lookup(o) }
        end
      end

      describe "flat_fetch" do
        it "works" do
          assert { TacticInfo.flat_fetch("金底の歩") }
        end
      end

      it "fuzzy_flat_lookup" do
        assert { TacticInfo.fuzzy_flat_lookup("嬉野") }
        assert { TacticInfo.fuzzy_flat_lookup("角頭歩") }
        assert { TacticInfo.fuzzy_flat_lookup("アヒル") }
        assert { TacticInfo.fuzzy_flat_lookup("阪田流向かい飛車") }
      end

      it "all_elements" do
        assert { TacticInfo.all_elements.include?(AttackInfo.fetch("棒銀")) }
      end

      it "all_elements_hash" do
        assert { TacticInfo.all_elements_hash[:"棒銀"] }
        assert { TacticInfo.all_elements_hash[:"美濃囲い"]       }
      end

      it "name" do
        assert { TacticInfo[:attack].name == "戦型" }
      end
    end
  end
end
