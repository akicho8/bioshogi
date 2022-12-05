require "spec_helper"

module Bioshogi
  module Xtech
    describe TechniqueInfo do
      def xcontainer_new
        Xcontainer.new.tap do |e|
          e.params[:skill_monitor_enable] = true
          e.params[:skill_monitor_technique_enable] = true
        end
      end

      it "金底の歩" do
        xcontainer = xcontainer_new
        xcontainer.placement_from_bod(<<~EOT)
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
        xcontainer.execute("31歩打")
        assert { xcontainer.hand_logs.last.skill_set.technique_infos.first.key == :"金底の歩" }
      end

      it "パンツを脱ぐ" do
        board = Board.create_by_shape(<<~EOT)
        +---------------------------+
          |v玉v桂 ・ ・ ・ ・ ・ ・ ・|
        +---------------------------+
          EOT

        xcontainer = xcontainer_new
        xcontainer.placement_from_bod("#{board}\n手数＝1")
        xcontainer.execute("73桂")
        assert { xcontainer.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

        xcontainer = xcontainer_new
        xcontainer.placement_from_bod("#{board.flop}\n手数＝1")
        xcontainer.execute("33桂")
        assert { xcontainer.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

        xcontainer = xcontainer_new
        xcontainer.placement_from_bod("#{board.flip}\n手数＝0")
        xcontainer.execute("37桂")
        assert { xcontainer.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

        xcontainer = xcontainer_new
        xcontainer.placement_from_bod("#{board.flip.flop}\n手数＝0")
        xcontainer.execute("77桂")
        assert { xcontainer.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }
      end
    end
  end
end
