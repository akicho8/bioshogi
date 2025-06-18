require "spec_helper"

RSpec.describe Bioshogi::Container::Basic do
  it "works" do
    container = Bioshogi::Container::Basic.new
    container.placement_from_preset("平手")
    container.before_run_process
    assert { container.to_history_sfen(startpos_embed: true) == "position startpos" }
    assert { container.to_history_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
    assert { container.to_short_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
    container.pieces_set("▲銀△銀銀")
    # puts container
    assert { container.board.to_sfen == "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL" }
    assert { container.to_history_sfen(startpos_embed: true) == "position startpos" }
    container.execute("▲６八銀")
    assert { container.hand_logs.last.to_sfen == "7i6h" }
    assert { container.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h" }
    container.execute("△２四銀打")
    assert { container.hand_logs.last.to_sfen == "S*2d" }
    assert { container.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h S*2d" }
    assert { container.initial_state_board_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
    # puts container.board
    assert { container.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h S*2d" }
  end

  it "load_from_sfen" do
    container = Bioshogi::Container::Basic.new
    container.load_from_sfen(Bioshogi::Sfen.parse("position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d"))
    assert { container.to_history_sfen == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b S2s 1 moves 7i6h S*2d" }

    container = Bioshogi::Container::Basic.new
    container.load_from_sfen(Bioshogi::Sfen.parse("position startpos moves 7i6h"))
    assert { container.to_history_sfen(startpos_embed: true) == "position startpos moves 7i6h" }

    container = Bioshogi::Container::Basic.new
    container.load_from_sfen(Bioshogi::Sfen.parse("position startpos"))
    assert { container.to_history_sfen(startpos_embed: true) ==  "position startpos" }

    container = Bioshogi::Container::Basic.new
    container.load_from_sfen(Bioshogi::Sfen.parse("position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1"))
    assert { container.to_history_sfen == "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1" }
  end

  it "normalized_names_with_alias" do
    container = Bioshogi::Container::Basic.new
    container.player_at(:black).tag_bundle.attack_infos << Bioshogi::Analysis::AttackInfo["コーヤン流三間飛車"]
    container.player_at(:white).tag_bundle.defense_infos << Bioshogi::Analysis::DefenseInfo["美濃囲い"]
    assert { container.normalized_names_with_alias == ["コーヤン流三間飛車", "コーヤン流", "中田功XP", "美濃囲い"] }
  end

  it "not_enough_piece_box" do
    container = Bioshogi::Container::Basic.new
    container.placement_from_bod <<~EOT
    後手の持駒：香
    ９ ８ ７ ６ ５ ４ ３ ２ １
    +---------------------------+
      | ・v桂v銀v金v玉v金v銀v桂v香|一
    | ・v飛 ・ ・ ・ ・ ・v角 ・|二
    |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ ・ ・ ・ ・ ・|八
    | 香 桂 銀 金 ・ 金 銀 桂 ・|九
    +---------------------------+
      先手の持駒：飛
    EOT

    assert { container.to_piece_box == { :rook=>2, :lance=>3, :knight=>4, :silver=>4, :gold=>4, :king=>1, :bishop=>2, :pawn=>18 } }
    assert { container.not_enough_piece_box.to_s == "玉 香" }

    piece_box = container.not_enough_piece_box
    piece_box.delete(:king)
    assert { piece_box.to_s == "香" }
  end

  describe "placement_from_preset" do
    it "盤を反映する" do
      container = Bioshogi::Container::Basic.new
      container.placement_from_preset("5五将棋")
      assert { container.to_short_sfen == "position sfen 4rbsgk/8p/9/4P4/4KGSBR/9/9/9/9 b - 1" }
      assert { container.turn_info.handicap == false }
    end

    it "手番を反映する" do
      container = Bioshogi::Container::Basic.new
      container.placement_from_preset("香落ち")
      assert { container.turn_info.handicap }
    end

    it "持駒を反映する" do
      container = Bioshogi::Container::Basic.new
      container.placement_from_preset("バリケード将棋")
      assert { container.player_at(:black).piece_box.to_s == "飛 角 香" }
      assert { container.player_at(:white).piece_box.to_s == "飛 角 香" }
    end
  end

  it "交互に打ちながら戦況表示" do
    container = Bioshogi::Container::Basic.new
    container.placement_from_preset("平手")
    container.execute(["７六歩", "３四歩"])
    assert { container.turn_info.turn_offset == 2 }
    assert { container.turn_info.display_turn == 2 }
    container.judgment_message == "まで2手で後手の勝ち"
    assert { container.to_s == <<-EOT }
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
先手番
EOT
  end

  it "状態の復元" do
    container = Bioshogi::Container::Basic.facade(init: "▲１五玉 ▲１四歩 △１一玉 △１二歩", execute: ["１三歩成", "１三歩"])
    m2 = container.deep_dup
    assert { container.turn_info.turn_offset == m2.turn_info.turn_offset }
    assert { container.to_kif_a     == m2.to_kif_a }
    assert { container.to_ki2_a     == m2.to_ki2_a }
    assert { container.to_s              == m2.to_s }

    container.board.to_s_soldiers == m2.board.to_s_soldiers

    container.opponent_player.location                == m2.opponent_player.location
    container.opponent_player.piece_box.to_s          == m2.opponent_player.piece_box.to_s
    container.opponent_player.to_s_soldiers           == m2.opponent_player.to_s_soldiers
    container.opponent_player.executor.captured_soldier == m2.opponent_player.executor.captured_soldier
  end

  it "相手が前回打った位置を復元するので同歩ができる" do
    container = Bioshogi::Container::Basic.facade(init: "▲１五歩 △１三歩", execute: "１四歩")
    container = Marshal.load(Marshal.dump(container))
    container.execute("同歩")
    assert { container.opponent_player.executor.hand_log.to_kif_ki2 == ["１四歩(13)", "同歩"] }
  end

  it "同歩からの同飛になること" do
    object = Bioshogi::Simulator.run({ execute: "▲２六歩 △２四歩 ▲２五歩 △同歩 ▲同飛", board: "平手" })
    assert { object.container.to_ki2_a == ["▲２六歩", "△２四歩", "▲２五歩", "△同歩", "▲同飛"] }
  end

  it "フレームのサンドボックス実行(重要)" do
    container = Bioshogi::Container::Basic.facade(init: "▲１二歩", pieces_set: "▼歩")
    assert { container.player_at(:black).to_s_soldiers == "１二歩" }
    assert { container.player_at(:black).board.to_s_soldiers == "１二歩" }
    container.context_new { |e| e.player_at(:black).execute("２二歩打") }
    assert { container.player_at(:black).to_s_soldiers == "１二歩" }
    assert { container.player_at(:black).board.to_s_soldiers == "１二歩" }
  end

  it "「打」にすると Marshal.dump できない件→修正" do
    container = Bioshogi::Container::Basic.facade(execute: "１二歩打", pieces_set: "▼歩")
    container.deep_dup
  end

  describe "手数を得る" do
    before do
      @info = Bioshogi::Container::Basic.start
      @info.execute("76歩")
      @info.execute("34歩")
      @info.execute("22角成")
      @info.execute("同銀")
      @info.execute("55角")
      @info.execute("54歩")
      @info.execute("22角成")
    end

    it "駒が取られる直前の手数" do
      assert { @info.critical_turn == 2 }
    end

    it "「角と歩」以外の駒が取られる直前の手数" do
      assert { @info.outbreak_turn == 6 }
    end
  end
end
