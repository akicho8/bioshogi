require_relative "spec_helper"

module Warabi
  describe Brain do
    it do
      Board.dimensiton_change([3, 3]) do
        mediator = MediatorSimple.new
        mediator.pieces_set("▲歩")
        mediator.board.placement_from_shape <<~EOT
+---------+
| ・ ・ ・|
| ・ 歩 ・|
| ・ ・ ・|
+---------+
EOT
        brain = mediator.player_at(:black).brain
        brain.lazy_all_hands.collect(&:to_kif).should == ["▲２一歩成(22)", "▲３二歩打", "▲１二歩打", "▲３三歩打", "▲１三歩打"]
        brain.fast_score_list.collect { |e| e.merge(hand: e[:hand].to_kif).slice(:hand, :score) }.should == [
          {hand: "▲２一歩成(22)", score: 1305},
          {hand: "▲３二歩打",     score: 200},
          {hand: "▲１二歩打",     score: 200},
          {hand: "▲３三歩打",     score: 200},
          {hand: "▲１三歩打",     score: 200},
        ]
      end
    end

    it do
      [NegaAlphaDiver, NegaScoutDiver].each do |diver_class|
        Board.promotable_disable do
          Board.dimensiton_change([2, 5]) do
            mediator = MediatorSimple.new
            mediator.board.placement_from_shape <<~EOT
            +------+
            | ・v香|
            | ・v飛|
            | ・v歩|
            | ・ 飛|
            | ・ 香|
            +------+
              EOT
            brain = mediator.player_at(:black).brain(diver_class: diver_class)
            brain.diver_dive(depth_max: 1).last.first.to_kif.should == "▲１三飛(14)"
            brain.diver_dive(depth_max: 2).last.first.to_kif.should == "▲２四飛(14)"
            brain.diver_dive(depth_max: 3).last.first.to_kif.should == "▲１三飛(14)"
            brain.diver_dive(depth_max: 4).last.first.to_kif.should == "▲２四飛(14)"
          end
        end
      end
    end

    describe "自動的に打つ" do
      it "盤上の駒を動かす" do
        mediator = MediatorSimple.start
        assert mediator.player_at(:black).brain.lazy_all_hands.first
      end
      it "全手筋" do
        mediator = MediatorSimple.start
        mediator.player_at(:black).brain.lazy_all_hands.collect(&:to_kif).sort.should == ["▲９六歩(97)", "▲８六歩(87)", "▲７六歩(77)", "▲６六歩(67)", "▲５六歩(57)", "▲４六歩(47)", "▲３六歩(37)", "▲２六歩(27)", "▲１六歩(17)", "▲３八飛(28)", "▲４八飛(28)", "▲５八飛(28)", "▲６八飛(28)", "▲７八飛(28)", "▲１八飛(28)", "▲９八香(99)", "▲７八銀(79)", "▲６八銀(79)", "▲７八金(69)", "▲６八金(69)", "▲５八金(69)", "▲６八玉(59)", "▲５八玉(59)", "▲４八玉(59)", "▲５八金(49)", "▲４八金(49)", "▲３八金(49)", "▲４八銀(39)", "▲３八銀(39)", "▲１八香(19)"].sort
      end
    end

    it "盤上の駒の全手筋" do
      Board.dimensiton_change([1, 5]) do
        mediator = MediatorSimple.test1(init: "▲１五香")
        mediator.player_at(:black).brain.move_hands.collect(&:to_kif).should == ["▲１四香(15)", "▲１三香成(15)", "▲１二香成(15)", "▲１一香成(15)"]
      end
    end

    it "一番得するように打つ" do
      Board.dimensiton_change([2, 2]) do
        mediator = MediatorSimple.test1(init: "▲１二歩", pieces_set: "▲歩")
        mediator.player_at(:black).brain.fast_score_list.collect { |e| {hand: e[:hand].to_kif, score: e[:score]} }.should == [{:hand=>"▲１一歩成(12)", :score=>1305}, {:hand=>"▲２二歩打", :score=>200}]
      end
    end
  end
end
