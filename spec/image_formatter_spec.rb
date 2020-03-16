require_relative "spec_helper"

module Bioshogi
  describe ImageFormatter do
    it do
      parser = Parser.parse(<<~EOT, turn_limit: 10)
      後手の持駒：飛二 角 銀二 桂四 香四 歩九
      ９ ８ ７ ６ ５ ４ ３ ２ １
      +---------------------------+
        |v香v桂v銀v金v玉v金v銀v桂v香|一
      | ・v飛 ・ ・ ・ ・ ・v角 ・|二
      |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
      | ・ ・ ・v竜 竜v馬 馬 ・ ・|五
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
      | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
      | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
      | 香 桂 銀 金 玉 金 銀 桂 香|九
      +---------------------------+
        先手の持駒：角 金四 銀二 歩九
      EOT

      object = parser.image_formatter(width: 100, height: 100, flip: true)
      assert object.to_png[1..3] == "PNG"
    end

    # it do
    #   parser = Parser.file_parse("#{__dir__}/yagura.kif")
    #   turn_offset = parser.mediator.turn_info.turn_offset
    #
    #   (0..parser.mediator.turn_info.turn_offset).each do |i|
    #     parser = Parser.file_parse("#{__dir__}/yagura.kif", turn_limit: i)
    #     parser.image_formatter(width: 100, height: 100, flip: true)
    #   end
    # end
  end
end
