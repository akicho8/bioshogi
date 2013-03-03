# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe LiveFrame do
    it "交互に打ちながら戦況表示" do
      frame = LiveFrame.start
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
        frame = LiveFrame.start
        frame.piece_plot
        kif_info.move_infos.each{|move_info|
          frame.execute(move_info[:input])
          break
        }
        # puts frame.inspect
        # puts frame.humane_kif_logs.join(" ")
      }
    end

    # it "kif→ki2" do
    #   @result = KifFormat::Parser.parse(Pathname(__FILE__).dirname.join("sample1.kif"))
    #   frame = LiveFrame.start
    #   frame.piece_plot
    #   @result.move_infos.each{|move_info|
    #     # p move_info[:input]
    #     frame.execute(move_info[:input])
    #     # puts frame.inspect
    #   }
    #   # puts frame.inspect
    #   puts frame.simple_kif_logs.join(" ")
    # end

    if false
      it "CPU同士で対局" do
        frame = LiveFrame.start
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
      frame = LiveFrame.testcase3(:init => [["１五玉", "１四歩"], ["１一玉", "１二歩"]], :exec => ["１三歩成", "１三歩"])
      dup = frame.deep_dup
      frame.counter.should            == dup.counter
      frame.simple_kif_logs.should    == dup.simple_kif_logs
      frame.humane_kif_logs.should    == dup.humane_kif_logs
      frame.to_s.should               == dup.to_s

      frame.board.to_s_soldiers       == dup.board.to_s_soldiers

      frame.prev_player.location      == dup.prev_player.location
      frame.prev_player.to_s_pieces   == dup.prev_player.to_s_pieces
      frame.prev_player.to_s_soldiers == dup.prev_player.to_s_soldiers
      frame.prev_player.moved_point   == dup.prev_player.moved_point
      frame.prev_player.last_piece    == dup.prev_player.last_piece
    end

    it "相手が前回打った位置を復元するので同歩ができる" do
      frame = LiveFrame.testcase3(:init => ["１五歩", "１三歩"], :exec => "１四歩")
      frame = Marshal.load(Marshal.dump(frame))
      frame.execute("同歩")
      frame.prev_player.parsed_info.last_kif_pair.should == ["1四歩(13)", "同歩"]
    end

    it "同歩からの同飛になること" do
      frame = SimulatorFrame.new({:execute => "▲２六歩 △２四歩 ▲２五歩 △同歩 ▲同飛", :board => :default})
      frame.to_all_frames
      frame.humane_kif_logs.should == ["▲2六歩", "▽2四歩", "▲2五歩", "▽同歩", "▲同飛"]
    end
  end
end
