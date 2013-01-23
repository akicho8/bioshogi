# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe LiveFrame do
    it "交互に打ちながら戦況表示" do
      frame = LiveFrame.basic_instance
      frame.piece_plot
      frame.execute(["７六歩", "３四歩"])
      frame.inspect.should == <<-FIELD
3手目: ▲先手番
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩 ・v歩v歩|三
| ・ ・ ・ ・ ・ ・v歩 ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
▲先手の持駒:
▽後手の持駒:
FIELD
    end

    it "ファイル読み込み" do
      file = "../resources/竜王戦_ki2/*.ki2"
      file = "../resources/iphone_shogi_vs/kakinoki_vs_Bonanza.kif"
      file = "../resources/詰将棋/*.kif"
      file = "../resources/**/*.{kif,ki2}"
      file = "../resources/竜王戦_ki2/龍王戦2010-23 渡辺羽生-6.ki2"
      Pathname.glob(Pathname(__FILE__).dirname.join(file)).each{|file|
        # p file
        begin
          kif_info = Bushido.parse(file)
        rescue FileFormatError => error
          # p error
          next
        end
        frame = LiveFrame.basic_instance
        frame.piece_plot
        kif_info.move_infos.each{|move_info|
          frame.execute(move_info[:input])
          break
        }
        # puts frame.inspect
        # puts frame.kif2_logs.join(" ")
      }
    end

    # it "kif→ki2" do
    #   @result = KifFormat::Parser.parse(Pathname(__FILE__).dirname.join("sample1.kif"))
    #   frame = LiveFrame.basic_instance
    #   frame.piece_plot
    #   @result.move_infos.each{|move_info|
    #     # p move_info[:input]
    #     frame.execute(move_info[:input])
    #     # puts frame.inspect
    #   }
    #   # puts frame.inspect
    #   puts frame.kif_logs.join(" ")
    # end
  end
end
