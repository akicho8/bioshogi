require_relative "spec_helper"

module Bushido
  describe Mediator do
    it "交互に打ちながら戦況表示" do
      mediator = Mediator.start
      mediator.piece_plot
      mediator.execute(["７六歩", "３四歩"])
      mediator.turn_info.counter.should == 2
      mediator.turn_max.should == 2
      mediator.judgment_message == "まで2手で後手の勝ち"
      mediator.to_s.should == <<-EOT
後手の持駒：なし
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
先手の持駒：なし
手数＝2 △３四歩(33) まで
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
          kif_info = Parser.parse(file)
        rescue FileFormatError => error
          # p error
          next
        end
        mediator = Mediator.start
        mediator.piece_plot
        kif_info.move_infos.each{|move_info|
          mediator.execute(move_info[:input])
          break
        }
        # puts mediator.inspect
        # puts mediator.ki2_hand_logs.join(" ")
      }
    end

    # it "kif→ki2" do
    #   @result = KifParser::Parser.parse(Pathname(__FILE__).dirname.join("sample1.kif"))
    #   mediator = Mediator.start
    #   mediator.piece_plot
    #   @result.move_infos.each{|move_info|
    #     # p move_info[:input]
    #     mediator.execute(move_info[:input])
    #     # puts mediator.inspect
    #   }
    #   # puts mediator.inspect
    #   puts mediator.kif_hand_logs.join(" ")
    # end

    if false
      it "CPU同士で対局" do
        mediator = Mediator.start
        mediator.piece_plot
        loop do
          think_result = mediator.current_player.brain.think_by_minmax(depth: 0, random: true)
          hand = Bushido::Utils.mov_split_one(think_result[:hand])[:input]
          # hand = mediator.current_player.brain.all_hands.sample
          p hand
          mediator.execute(hand)
          p mediator
          last_piece_taken_from_opponent = mediator.reverse_player.last_piece_taken_from_opponent
          break
          if last_piece_taken_from_opponent && last_piece_taken_from_opponent.key == :king
            break
          end
        end
        p mediator.kif_hand_logs.join(" ")
      end
    end

    it "状態の復元" do
      mediator = Mediator.test(init: "▲１五玉 ▲１四歩 △１一玉 △１二歩", exec: ["１三歩成", "１三歩"])
      dup = mediator.deep_dup
      mediator.turn_info.counter.should            == dup.turn_info.counter
      mediator.kif_hand_logs.should    == dup.kif_hand_logs
      mediator.ki2_hand_logs.should     == dup.ki2_hand_logs
      mediator.to_s.should               == dup.to_s

      mediator.board.to_s_battlers       == dup.board.to_s_battlers

      mediator.reverse_player.location      == dup.reverse_player.location
      mediator.reverse_player.to_s_pieces   == dup.reverse_player.to_s_pieces
      mediator.reverse_player.to_s_battlers == dup.reverse_player.to_s_battlers
      mediator.reverse_player.last_piece_taken_from_opponent    == dup.reverse_player.last_piece_taken_from_opponent
    end

    it "相手が前回打った位置を復元するので同歩ができる" do
      mediator = Mediator.test(init: "▲１五歩 △１三歩", exec: "１四歩")
      mediator = Marshal.load(Marshal.dump(mediator))
      mediator.execute("同歩")
      mediator.reverse_player.runner.hand_log.to_kif_ki2.should == ["１四歩(13)", "同歩"]
    end

    it "同歩からの同飛になること" do
      mediator = SimulatorFrame.new({execute: "▲２六歩 △２四歩 ▲２五歩 △同歩 ▲同飛", board: "平手"})
      mediator.build_frames
      mediator.ki2_hand_logs.should == ["▲２六歩", "△２四歩", "▲２五歩", "△同歩", "▲同飛"]
    end

    it "Sequencer" do
      data = KifuDsl.define{}
      sequencer = Sequencer.new
      sequencer.pattern = data
      sequencer.evaluate
      sequencer.frames
    end

    it "フレームのサンドボックス実行(重要)" do
      mediator = Mediator.test(init: "▲１二歩")
      mediator.player_b.to_s_battlers.should == "１二歩"
      mediator.player_b.board.to_s_battlers.should == "１二歩"
      mediator.sandbox_for { mediator.player_b.execute("２二歩打") }
      mediator.player_b.to_s_battlers.should == "１二歩"
      mediator.player_b.board.to_s_battlers.should == "１二歩"
    end

    it "「打」にすると Marshal.dump できない件→修正" do
      mediator = Mediator.test(exec: "１二歩打")
      mediator.deep_dup
    end

    #     it "debug" do
    #       mediator = Mediator.start
    #       mediator.board_reset_by_shape(<<~BOARD)
    # +------+
    # | 金 ・|
    # | ・ 金|
    # +------+
    # BOARD
    #       puts mediator.board.to_s
    #       mediator.execute("２二金直上")
    #       puts mediator.board.to_s
    #     end

    # it "盤面初期設定" do
    #   def board_reset_test(value)
    #     mediator = Mediator.new
    #     mediator.board_reset(value)
    #     mediator.board.to_s
    #   end
    #   puts board_reset_test("角落ち")
    #   # board_reset_test("平手").should == "▲１七歩 ▲１九香 ▲２七歩 ▲２九桂 ▲２八飛 ▲３七歩 ▲３九銀 ▲４七歩 ▲４九金 ▲５七歩 ▲５九玉 ▲６七歩 ▲６九金 ▲７七歩 ▲７九銀 ▲８七歩 ▲８九桂 ▲８八角 ▲９七歩 ▲９九香 △１一香 △１三歩 △２一桂 △２三歩 △２二角 △３一銀 △３三歩 △４一金 △４三歩 △５一玉 △５三歩 △６一金 △６三歩 △７一銀 △７三歩 △８一桂 △８三歩 △８二飛 △９一香 △９三歩"
    #   # board_reset_test("▲" => "角落ち")
    # end

    # it "XtraPattern" do
    #   XtraPattern.reload_all
    #   XtraPattern.each{|v|
    #     p v
    #     mediator = SimulatorFrame.new(v)
    #     puts mediator.board
    #     mediator.build_frames
    #   }
    # end

    # it "歩を打つとエラー？？？ → かんけいなし" do
    #   value = {
    #     pieces: {black: "歩"},
    #     execute: "▲５五歩",
    #     board: "全落ち",
    #   }
    #   mediator = SimulatorFrame.new(value)
    #   p mediator
    #   # puts mediator.board
    #   mediator.build_frames{|f|p f}
    # end

    # if true
    #   it "これがおかしい。▲９七歩打 で Marshal.dump に失敗する。MatchData を誰がもっているのか。" do
    #     mediator = SimulatorFrame.new(value)
    #     # puts mediator.board
    #     mediator.build_frames{|f|}
    #     # mediator.build_frames
    #   end
    # end

    if false
      it "XtraPattern", p: true do
        XtraPattern.reload_all
        XtraPattern.each do |pattern|
          if pattern[:dsl]
            mediator = Sequencer.new
            mediator.pattern = pattern[:dsl]
            mediator.evaluate
            # p mediator.frames
          else
            mediator = SimulatorFrame.new(pattern)
            mediator.build_frames
            # mediator.build_frames{|e|p e}
          end
        end
      end
    end
  end
end
