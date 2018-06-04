require_relative "spec_helper"

module Warabi
  describe TacticInfo do
    it "すべての戦法の判定" do
      TacticInfo.all_elements.each do |e|
        file = Pathname.glob("#{__dir__}/../experiment/#{e.tactic_info.name}/#{e.key}.*").first
        info = Parser.file_parse(file)
        info.mediator_run
        matches = info.mediator.players.collect { |player|
          player.skill_set.public_send(e.tactic_info.list_key).normalize.collect(&:key)
        }.flatten
        assert { matches.include?(e.key) }
      end
    end

    it "すべての戦法に参考URLがある" do
      TacticInfo.all_elements.each do |e|
        assert { e.urls }
      end
    end
  end
end
