require "spec_helper"

module Bioshogi
  module Explain
    RSpec.describe TechniqueInfo do
      def container_new
        Container::Basic.new.tap do |e|
          e.params[:skill_monitor_enable] = true
          e.params[:skill_monitor_technique_enable] = true
        end
      end

      it "金底の歩" do
        container = container_new
        container.placement_from_bod(<<~EOT)
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
        container.execute("31歩打")
        assert { container.hand_logs.last.skill_set.technique_infos.first.key == :"金底の歩" }
      end

      it "パンツを脱ぐ" do
        board = Board.create_by_shape(<<~EOT)
        +---------------------------+
          |v玉v桂 ・ ・ ・ ・ ・ ・ ・|
        +---------------------------+
          EOT

        container = container_new
        container.placement_from_bod("#{board}\n手数＝1")
        container.execute("73桂")
        assert { container.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

        container = container_new
        container.placement_from_bod("#{board.flop}\n手数＝1")
        container.execute("33桂")
        assert { container.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

        container = container_new
        container.placement_from_bod("#{board.flip}\n手数＝0")
        container.execute("37桂")
        assert { container.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }

        container = container_new
        container.placement_from_bod("#{board.flip.flop}\n手数＝0")
        container.execute("77桂")
        assert { container.hand_logs.last.skill_set.technique_infos.first.key == :"パンツを脱ぐ" }
      end
    end
  end
end
