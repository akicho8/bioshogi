require "spec_helper"

module Bioshogi
  module Yomiage
    describe Formatter do
      it "works" do
        container = Container::Basic.new
        container.placement_from_bod(<<~EOT)
        上手の持駒：飛
        ９ ８ ７ ６ ５ ４ ３ ２ １
        +---------------------------+
        |v香v桂v銀v金v玉v金v銀v桂v香|一
        | ・ ・ ・ ・v全 ・ ・v角 ・|二
        |v歩 ・v歩v歩v歩v歩v歩 銀v歩|三
        | ・ ・ ・ ・ 銀 ・ ・ ・ ・|四
        | ・v飛 ・ ・ ・ ・ ・ ・ ・|五
        | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
        | 歩 歩 歩 歩 歩 歩 歩 ・ 歩|七
        | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
        | 香 桂 銀 金 玉 金 ・ 桂 香|九
        +---------------------------+
          下手の持駒：なし
        手数＝1

        後手番
        EOT
        container.execute("68銀")
        assert { container.hand_logs.last.yomiage }
        container.execute("55飛打")
        assert { container.hand_logs.last.yomiage }
        container.execute("34銀成")
        assert { container.hand_logs.last.yomiage }
        container.execute("57飛成")
        assert { container.hand_logs.last.yomiage }
        container.execute("53銀不成")
        assert { container.hand_logs.last.yomiage }
        container.execute("同成銀")
        assert { container.hand_logs.last.yomiage }
      end
    end
  end
end
