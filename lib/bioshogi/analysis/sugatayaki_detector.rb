module Bioshogi
  module Analysis
    class SugatayakiDetector
      delegate :win_side_location, :container, to: :@skill_embed

      def initialize(skill_embed)
        @skill_embed = skill_embed
      end

      def call
        if valid?
          win_player.skill_set.list_push(tag)

          # 最後の手にも入れておく
          container.hand_logs.last&.then do |hand_log|
            hand_log.skill_set.list_push(tag)
          end

          # tp info
        end
      end

      def tag
        Analysis::NoteInfo["穴熊の姿焼き"]
      end

      def info
        {
          "閾値"       => Piece::PieceScore.sure_victory_score,
          "勝者の得点" => win_player.current_score,
          "敗者の得点" => lose_player.current_score,
          "得点差"     => win_player.current_score - lose_player.current_score,
        }
      end

      def valid?
        unless win_side_location # 勝ち負けがはっきりしているか？
          return
        end
        unless anaguma_formation? # 相手が穴熊状態か？
          return
        end
        # unless strong_piece_completed? # 大駒コンプリートしている？ → overwhelming_score? の方が汎用的
        #   return
        # end
        unless win_player.overwhelming_score? # 自分が圧倒的な戦力を持っているか？
          return
        end
        true
      end

      # 左右どちらかに相手の穴熊が存在する？
      def anaguma_formation?
        sub_anaguma_formation?(false) || sub_anaguma_formation?(true)
      end

      # 角に相手の穴熊が存在する？
      def sub_anaguma_formation?(flop)
        true &&
          lose_side_soldier_at("19", flop).try { piece.key == :king } && # 角に玉がある
          lose_side_soldier_at("18", flop) &&
          lose_side_soldier_at("29", flop) &&
          lose_side_soldier_at("28", flop)
      end

      # 勝ったプレイヤー
      def win_player
        @win_player ||= container.player_at(win_side_location)
      end

      # 負けたプレイヤー
      def lose_player
        @lose_player ||= container.player_at(lose_side_location)
      end

      # 負けた側
      def lose_side_location
        @lose_side_location ||= win_side_location.flip
      end

      # 負けた方の盤上の駒を得る
      def lose_side_soldier_at(place, flop)
        place = Place[place]
        if flop
          place = place.flop
        end
        place = place.white_then_flip(lose_side_location)
        if soldier = container.board[place]
          if soldier.location == lose_side_location
            soldier
          end
        end
      end
    end
  end
end
