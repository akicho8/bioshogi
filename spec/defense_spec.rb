require_relative "spec_helper"

module Bushido
  describe Mediator do
    describe "囲い" do
      it "囲いチェック", :if => Bushido.config.defense_form_check do
        info = Parser.file_parse("#{__dir__}/yagura.kif")
        info.mediator_run
        info.header_as_string.should == <<~EOT
開始日時：1981/05/15 09:00:00
棋戦：名将戦
場所：東京「将棋会館」
手合割：平手
先手：加藤一二三
後手：原田泰夫
戦型：矢倉
先手の囲い：金矢倉
後手の囲い：
        EOT
      end
    end
  end
end
