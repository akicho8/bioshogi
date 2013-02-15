# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe LiveFrame do
    it "交互に打ちながら戦況表示" do
      frame = LiveFrame.basic_instance
      frame.piece_plot
      frame.execute(["７六歩", "３四歩"])
      frame.inspect.should == <<-EOT
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
EOT
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

    if false
      it "CPU同士で対局" do
        frame = LiveFrame.basic_instance
        frame.piece_plot
        while true
          way = frame.current_player.generate_way
          p way
          p frame
          frame.execute(way)
          last_piece = frame.prev_player.last_piece
          if last_piece && last_piece.sym_name == :king
            break
          end
        end
      end
    end

    it "状態の復元" do
      frame1 = LiveFrame.testcase3(:init => [["１五玉", "１四歩"], ["１一玉", "１二歩"]], :exec => ["１三歩成", "１三歩"])
      frame2 = Marshal.load(Marshal.dump(frame1))
      frame1.count.should              == frame2.count
      frame1.kif_logs.should           == frame2.kif_logs
      frame1.kif2_logs.should          == frame2.kif2_logs
      frame1.board.to_s_soldiers       == frame2.board.to_s_soldiers
      frame1.prev_player.to_s_pieces   == frame2.prev_player.to_s_pieces
      frame1.prev_player.to_s_soldiers == frame2.prev_player.to_s_soldiers
      frame1.to_s.should               == frame2.to_s
    end

    it "相手が前回打った位置が復元できてない転けるテスト" do
      # md = /\A(?<point>..)/.match("１四")
      # p md[:point]
      # point = Point.parse(md[:point])
      # p Marshal.dump(point)

      frame = LiveFrame.testcase3(:init => ["１五歩", "１三歩"], :exec => "１四歩")
      pt = frame.prev_player.parsed_info.point

      p pt.class

      Marshal.dump(pt)

      # bin = Marshal.dump(frame)
      # # frame = Marshal.load(bin)
      # # p frame.next_player
      # # frame.execute("同歩")
      # # p frame.prev_player.parsed_info.last_kif_pair
    end
  end
end
