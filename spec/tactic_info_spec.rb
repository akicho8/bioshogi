require "spec_helper"

module Bioshogi
  describe TacticInfo do
    describe "すべての戦法の判定", tactic: true do
      TacticInfo.all_elements.each do |e|
        it e.key do
          file = Pathname.glob("#{__dir__}/../lib/bioshogi/#{e.tactic_info.name}/#{e.key}.{kif,ki2}").first # 拡張子を "*" とすると ruby 2.5.1 から(？) 動かない
          info = Parser.parse(file)
          info.xcontainer_run_once
          if ["居玉", "力戦", "相居玉", "背水の陣", "相居飛車", "対振り", "相振り", "対抗型"].include?(e.key.to_s)
            next
          end
          assert { info.xcontainer.normalized_names_with_alias.include?(e.key.to_s) }
        end
      end
    end

    it "すべての戦法に参考URLがある" do
      TacticInfo.all_elements.each do |e|
        assert { e.urls }
      end
    end

    describe "flat_lookup" do
      it "works" do
        assert { TacticInfo.flat_lookup("金底の歩") }
      end
      it "文字列でなくても to_s してから探す" do
        o = Object.new
        def o.to_s
          "金底の歩"
        end
        assert { TacticInfo.flat_lookup(o) }
      end
    end
  end
end
