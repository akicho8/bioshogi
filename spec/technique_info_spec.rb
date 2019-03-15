require_relative "spec_helper"

module Warabi
  describe TechniqueInfo do
    def mediator_new
      Mediator.new.tap do |e|
        e.params[:skill_monitor_enable] = true
        e.params[:skill_monitor_technique_enable] = true
      end
    end

    it "金底の歩" do
      mediator = mediator_new
      mediator.placement_from_bod(<<~EOT)
後手の持駒：歩
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・v金 ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
+---------------------------+
先手の持駒：歩
手数＝1

先手番
EOT
      mediator.execute("31歩打")
      assert { mediator.hand_logs.last.skill_set.technique_infos.first.key == :"金底の歩" }
    end

    it "パンツを脱ぐ" do
      board = Board.new
      board.board_set_any(<<~EOT)
+---------------------------+
|v玉v桂 ・ ・ ・ ・ ・ ・ ・|
+---------------------------+
        EOT

      mediator = mediator_new
      mediator.placement_from_bod("#{board}\n手数＝1")
      mediator.execute("73桂")
      assert { mediator.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

      mediator = mediator_new
      mediator.placement_from_bod("#{board.horizontal_flip}\n手数＝1")
      mediator.execute("33桂")
      assert { mediator.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

      mediator = mediator_new
      mediator.placement_from_bod("#{board.flip}\n手数＝0")
      mediator.execute("37桂")
      assert { mediator.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

      mediator = mediator_new
      mediator.placement_from_bod("#{board.flip.horizontal_flip}\n手数＝0")
      mediator.execute("77桂")
      assert { mediator.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }
    end
  end
end
