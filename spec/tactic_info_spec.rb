require_relative "spec_helper"

module Bioshogi
  describe TacticInfo do
    it "すべての戦法の判定" do
      TacticInfo.all_elements.each do |e|
        # if ["手得角交換型"].include?(e.key.to_s)
        #   next
        # end
        file = Pathname.glob("#{__dir__}/../lib/bioshogi/#{e.tactic_info.name}/#{e.key}.{kif,ki2}").first # 拡張子を "*" とすると ruby 2.5.1 から(？) 動かない
        info = Parser.file_parse(file)
        info.mediator_run
        matches = info.mediator.players.collect { |player|
          player.skill_set.list_of(e).normalize.collect(&:key)
        }.flatten
        if ["力戦", "居玉", "相居玉", "相居飛車", "相居飛車", "対振り", "相振り", "対抗型", "背水の陣"].include?(e.key.to_s)
          next
        end
        assert { matches.include?(e.key) }
      end
    end

    it "すべての戦法に参考URLがある" do
      TacticInfo.all_elements.each do |e|
        assert { e.urls }
      end
    end

    it "flat_lookup" do
      assert { TacticInfo.flat_lookup("金底の歩") }
    end
  end
end
