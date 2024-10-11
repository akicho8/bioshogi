require "spec_helper"

module Bioshogi
  describe BoardParser::CompareBoardParser do
    it "他の駒以外のものも拾える" do
      info = BoardParser::CompareBoardParser.parse(<<~EOT)
      +------+
        |v○v歩|
      | ・ 歩|
      +------+
        EOT
      info.other_objects == [{place: Place["21"], location: Location[:white], something: "○"}]
    end

    id do
      board_parser = BoardParser::CompareBoardParser.parse(<<~EOT)
      +------------+
        | ・~銀 ★v香|
      |!歩@歩?歩*歩|
      +------------+
        EOT

      assert board_parser.soldiers                      # => [<Bioshogi::Soldier "△１一香">, <Bioshogi::Soldier "▲３二歩">]
      assert board_parser.trigger_soldiers              # => [<Bioshogi::Soldier "▲４二歩">, <Bioshogi::Soldier "▲３二歩">]
      assert board_parser.other_objects_hash_ary        # => {"★"=>[{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}]}
      assert board_parser.other_objects_hash            # => {"★"=>{#<Bioshogi::Place ２一>=>{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}
      assert board_parser.other_objects_loc_places_hash # => {:black=>{"★"=>{#<Bioshogi::Place ２一>=>{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}, :white=>{"★"=>{#<Bioshogi::Place ８九>=>{:place=>#<Bioshogi::Place ８九>, :prefix_char=>" ", :something=>"★"}}}}
      assert board_parser.any_exist_soldiers            # => [<Bioshogi::Soldier "△２二歩">, <Bioshogi::Soldier "▲１二歩">]
      assert board_parser.not_exist_soldiers           # => [<Bioshogi::Soldier "▲３一銀">]
      assert board_parser.primary_soldiers              # => [<Bioshogi::Soldier "▲４二歩">, <Bioshogi::Soldier "▲３二歩">]
    end
  end
end
