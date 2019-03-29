require_relative "spec_helper"

module Bioshogi
  describe TacticInfo do
    it "すべての戦法の判定" do
      TacticInfo.all_elements.each do |e|
        file = Pathname.glob("#{__dir__}/../experiment/#{e.tactic_info.name}/#{e.key}.{kif,ki2}").first # 拡張子を "*" とすると ruby 2.5.1 から(？) 動かない
        info = Parser.file_parse(file)
        info.mediator_run
        matches = info.mediator.players.collect { |player|
          player.skill_set.public_send(e.tactic_info.list_key).normalize.collect(&:key)
        }.flatten
        if e.key == :"居玉" || e.key == :"相居玉"
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
