require "spec_helper"

module Bioshogi
  module Ai
    describe Brain do
      it "初手が嬉野流になるよう誘導される" do
        container = Container::Basic.start
        player = container.player_at(:black)
        brain = container.player_at(:black).brain(diver_class: Diver::NegaAlphaDiver, evaluator_class: Evaluator::Level3)
        @records = brain.iterative_deepening(depth_max_range: 0..0)
        assert { @records.first[:hand].to_s == "▲６八銀(79)" }
      end

      it "works" do
        Dimension.wh_change([3, 3]) do
          container = Container::Simple.new
          container.pieces_set("▲歩")
          container.board.placement_from_shape <<~EOT
          +---------+
            | ・ ・ ・|
          | ・ 歩 ・|
          | ・ ・ ・|
          +---------+
            EOT
          brain = container.player_at(:black).brain
          assert { brain.create_all_hands(promoted_only: true).collect(&:to_kif) == ["▲２一歩成(22)", "▲３二歩打", "▲１二歩打", "▲３三歩打", "▲１三歩打"] }
          assert do
            brain.fast_score_list.collect { |e| e.merge(hand: e[:hand].to_kif).slice(:hand, :score) } == [
              { hand: "▲２一歩成(22)", score: 1305, },
              { hand: "▲３二歩打",     score: 200,  },
              { hand: "▲１二歩打",     score: 200,  },
              { hand: "▲３三歩打",     score: 200,  },
              { hand: "▲１三歩打",     score: 200,  },
            ]
          end
        end
      end

      it "works" do
        [Diver::NegaAlphaDiver, Diver::NegaScoutDiver].each do |diver_class|
          Dimension::PlaceY.promotable_disabled do
            Dimension.wh_change([2, 5]) do
              container = Container::Simple.new
              container.board.placement_from_shape <<~EOT
              +------+
                | ・v香|
              | ・v飛|
              | ・v歩|
              | ・ 飛|
              | ・ 香|
              +------+
                EOT
              brain = container.player_at(:black).brain(diver_class: diver_class)
              assert { brain.diver_dive(depth_max: 1)[1].first.to_kif == "▲１三飛(14)" }
              assert { brain.diver_dive(depth_max: 2)[1].first.to_kif == "▲２四飛(14)" }
              assert { brain.diver_dive(depth_max: 3)[1].first.to_kif == "▲１三飛(14)" }
              assert { brain.diver_dive(depth_max: 4)[1].first.to_kif == "▲２四飛(14)" }
            end
          end
        end
      end

      describe "自動的に打つ" do
        it "盤上の駒を動かす" do
          container = Container::Simple.start
          assert { container.player_at(:black).brain.create_all_hands(promoted_only: true).first }
        end
        it "全手筋" do
          container = Container::Simple.start
          assert { container.player_at(:black).brain.create_all_hands(promoted_only: true).collect(&:to_kif).sort == ["▲９六歩(97)", "▲８六歩(87)", "▲７六歩(77)", "▲６六歩(67)", "▲５六歩(57)", "▲４六歩(47)", "▲３六歩(37)", "▲２六歩(27)", "▲１六歩(17)", "▲３八飛(28)", "▲４八飛(28)", "▲５八飛(28)", "▲６八飛(28)", "▲７八飛(28)", "▲１八飛(28)", "▲９八香(99)", "▲７八銀(79)", "▲６八銀(79)", "▲７八金(69)", "▲６八金(69)", "▲５八金(69)", "▲６八玉(59)", "▲５八玉(59)", "▲４八玉(59)", "▲５八金(49)", "▲４八金(49)", "▲３八金(49)", "▲４八銀(39)", "▲３八銀(39)", "▲１八香(19)"].sort }
        end
      end

      it "盤上の駒の全手筋" do
        Dimension.wh_change([1, 5]) do
          container = Container::Simple.facade(init: "▲１五香")
          assert { container.player_at(:black).move_hands(promoted_only: true).collect(&:to_kif) == ["▲１四香(15)", "▲１三香成(15)", "▲１二香成(15)", "▲１一香成(15)"] }
        end
      end

      it "一番得するように打つ" do
        Dimension.wh_change([2, 2]) do
          container = Container::Simple.facade(init: "▲１二歩", pieces_set: "▲歩")
          assert { container.player_at(:black).brain.fast_score_list.collect { |e| {hand: e[:hand].to_kif, score: e[:score]} } == [{:hand=>"▲１一歩成(12)", :score=>1305, }, {:hand=>"▲２二歩打", :score=>200}] }
        end
      end
    end
  end
end
