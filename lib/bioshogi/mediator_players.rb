# frozen-string-literal: true

module Bioshogi
  concern :MediatorPlayers do
    class_methods do
      def start
        new.tap do |e|
          e.placement_from_preset("平手")
        end
      end
    end

    attr_reader :players

    def players
      @players ||= LocationInfo.collect do |e|
        Player.new(mediator: self, location_info: e)
      end
    end

    # player_at(-1) でも後手を取得できる
    def player_at(location_info)
      players[LocationInfo.fetch(location_info).code]
    end

    # 現在の手番のプレイヤー
    # 引数の数値だけ手番が入れ替わる
    def current_player(diff = 0)
      players[turn_info.current_location(diff).code]
    end

    # 現在の手番の相手プレイヤー
    def opponent_player
      current_player(1)
    end

    # 次のプレイヤー(つまり相手)
    def next_player
      opponent_player
    end

    # 対局が終わった時点での勝者
    def win_player
      opponent_player
    end

    # 対局が終わった時点での敗者
    def lose_player
      current_player
    end

    # 両方のプレイヤーの駒台をクリア
    def piece_box_clear
      players.each { |e| e.piece_box.clear }
    end

    # 両者の(別名を含む)スキル名のリストを合わせてユニークにしたもの
    # つまりその対局に関連するすべてのタグに相当する
    def normalized_names_with_alias
      players.flat_map { |e| e.skill_set.normalized_names_with_alias }.uniq
    end

    # def basic_score
    #   evaluator.basic_score
    # end

    # 互いに王手されている局面か？ (ありえない)
    def position_invalid?
      players.all?(&:mate_advantage?)
    end

    concerning :OtherMethods do
      # 文字列で両者に駒を配る
      def pieces_set(str)
        Piece.s_to_h2(str).each do |location_key, counts|
          player_at(location_key).piece_box.set(counts)
        end
      end
    end

    concerning :TurnMethods do
      attr_writer :turn_info

      def turn_info
        @turn_info ||= TurnInfo.new
      end
    end

    concerning :PieceCountCheckMethods do
      # 両者の駒を一つに集める
      def to_piece_box
        piece_box = PieceBox.new
        piece_box = players.inject(piece_box) { |a, e| a.add(e.piece_box) }
        piece_box.add(board.to_piece_box)
      end

      # 足りない駒が入っている箱を返す
      def not_enough_piece_box
        all = PieceBox.real_box
        all.safe_sub(to_piece_box)
      end
    end
  end
end
