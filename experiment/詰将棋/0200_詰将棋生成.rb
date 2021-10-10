require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
# Board.promotable_disable
# Board.dimensiton_change([5, 5])

class App
  def run
    builder_infos = {
      nantedume: 3,
      try_count: 10,
      motigoma: "銀2",
      soldiers_board_on: [
        { location: :white, pieces: "玉",  xy_ranges: [1..2, 1..2] },
        { location: :black, pieces: "金",  xy_ranges: [2..3, 2..3] },
      ],
    }
    builder = Builder.new(builder_infos).run
    builder
  end

  class Builder
    attr_accessor :params
    attr_accessor :mediator

    def initialize(params = {})
      @params = params
    end

    def run
      board_setup
      black_piece_box_setup
      mate_validation
      self
    end

    def board_setup
      try_count.times do
        @mediator = Mediator.new

        @piece_box = PieceBox.all_in_create
        @piece_box.add(king: -1)
        mediator.player_at(:white).piece_box.add(@piece_box)

        @params[:soldiers_board_on].each do |e|
          soldiers_board_on(e)
        end

        unless mediator.player_at(:white).mate_danger?
          break
        end

        mediator = nil
      end
    end

    def black_piece_box_setup
      if mediator
        # 攻め手の駒台へ
        Piece.s_to_a(params[:motigoma]).each do |piece|
          mediator.player_at(:white).piece_box.add(piece => -1)
          mediator.player_at(:black).piece_box.add(piece => 1)
        end
      end
    end

    def mate_validation
      puts mediator.to_bod

      @mate_records = []
      mate_proc = -> player, score, hand_route {
        @mate_records << {"評価値" => score, "詰み筋" => hand_route.collect(&:to_s).join(" "), "詰み側" => player.location.to_s, "攻め側の持駒" => player.op.piece_box.to_s}
      }

      brain = mediator.player_at(:black).brain(diver_class: Diver::NegaAlphaMateDiver) # 詰将棋専用探索
      @records = brain.iterative_deepening(depth_max_range: params[:nantedume]..params[:nantedume], mate_mode: true, no_break: true, motigoma_zero_denaito_dame: true, mate_proc: mate_proc)

      @records = @records.find_all { |e| e[:black_side_score] >= 1 }

      tp Brain.human_format(@records)
      tp @mate_records

      mediator.before_run_process
      if record = @records.first
        ([record[:hand]] + record[:best_pv]).each do |e|
          pp e
          mediator.execute(e)
          puts mediator.to_bod
        end
      end

      puts "------------------------------"
      puts mediator.to_csa
      puts mediator.to_long_sfen
      puts mediator.to_sfen
      puts "------------------------------"
    end

    def soldiers_board_on(location:, pieces: [], xy_ranges: [])
      Piece.s_to_a(pieces).each do |piece|
        mediator.player_at(:white).piece_box.add(piece => -1)

        blank_places = mediator.board.blank_places.entries
        soldier = nil
        256.times do
          # 空いている位置を探す
          place = nil
          loop do
            xy = 2.times.collect { |i| rand(xy_ranges[i] || (1..4)) }.join
            place = Place.fetch(xy)
            unless mediator.board[place]
              break
            end
          end

          # 成るか成らないか
          promoted = false
          if piece.promotable?
            promoted = (rand <= 0.5)
          end

          soldier = Soldier.create(piece: piece, promoted: promoted, location: Location[location], place: place)

          # 死に駒なら作りなおし
          unless soldier.alive?
            next
          end

          mediator.board.place_on(soldier)
          break
        end
      end
    end

    def try_count
      params[:try_count] || 10
    end
  end
end

App.new.run
# >> 後手の持駒：飛二 角二 金三 銀二 桂四 香四 歩十八
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・v玉 ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ 金 ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：銀二
# >> 手数＝0 まで
# >> 
# >> 先手番
# >> |------+------------+--------------------------------+--------+------------+----------|
# >> | 順位 | 候補手     | 読み筋                         | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+------------+--------------------------------+--------+------------+----------|
# >> |    1 | ▲３二銀打 | △１一玉(21) ▲２二銀打 (詰み) |      1 |          3 | 0.479042 |
# >> |------+------------+--------------------------------+--------+------------+----------|
# >> |--------+------------------------------------+--------+--------------|
# >> | 評価値 | 詰み筋                             | 詰み側 | 攻め側の持駒 |
# >> |--------+------------------------------------+--------+--------------|
# >> |     -1 | ▲３二銀打 △１一玉(21) ▲２二銀打 | △     |              |
# >> |     -1 | ▲３二銀打 △１一玉(21) ▲１二銀打 | △     |              |
# >> |--------+------------------------------------+--------+--------------|
# >> <▲３二銀打>
# >> 後手の持駒：飛二 角二 金三 銀二 桂四 香四 歩十八
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・v玉 ・|一
# >> | ・ ・ ・ ・ ・ ・ 銀 ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ 金 ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：銀
# >> 手数＝1 ▲３二銀打 まで
# >> 
# >> 後手番
# >> <△１一玉(21)>
# >> 後手の持駒：飛二 角二 金三 銀二 桂四 香四 歩十八
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・v玉|一
# >> | ・ ・ ・ ・ ・ ・ 銀 ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ 金 ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：銀
# >> 手数＝2 △１一玉(21) まで
# >> 
# >> 先手番
# >> <▲２二銀打>
# >> 後手の持駒：飛二 角二 金三 銀二 桂四 香四 歩十八
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・v玉|一
# >> | ・ ・ ・ ・ ・ ・ 銀 銀 ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ 金 ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝3 ▲２二銀打 まで
# >> 
# >> 後手番
# >> "(詰み)"
# >> 後手の持駒：飛二 角二 金三 銀二 桂四 香四 歩十八
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・v玉|一
# >> | ・ ・ ・ ・ ・ ・ 銀 銀 ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ 金 ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝3 ▲２二銀打 まで
# >> 
# >> 後手番
# >> ------------------------------
# >> P1 *  *  *  *  *  *  *  * -OU
# >> P2 *  *  *  *  *  * +GI+GI * 
# >> P3 *  *  *  *  *  *  * +KI * 
# >> P4 *  *  *  *  *  *  *  *  * 
# >> P5 *  *  *  *  *  *  *  *  * 
# >> P6 *  *  *  *  *  *  *  *  * 
# >> P7 *  *  *  *  *  *  *  *  * 
# >> P8 *  *  *  *  *  *  *  *  * 
# >> P9 *  *  *  *  *  *  *  *  * 
# >> P-00HI00HI00KA00KA00KI00KI00KI00GI00GI00KE00KE00KE00KE00KY00KY00KY00KY00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU
# >> sfen 8k/6SS1/7G1/9/9/9/9/9/9 w 2r2b3g2s4n4l18p 4
# >> position sfen 7k1/9/7G1/9/9/9/9/9/9 b 2S2r2b3g2s4n4l18p 1 moves S*3b 2a1a S*2b
# >> ------------------------------
