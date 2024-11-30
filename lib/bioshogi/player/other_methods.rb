# frozen-string-literal: true

module Bioshogi
  class Player
    module OtherMethods
      STRONG_PIECE_ALL_COUNT = Location.count * Piece.strong_pieces.count

      attr_writer :king_moved_counter
      attr_accessor :king_place
      attr_accessor :king_first_moved_turn # 玉が最初に動いた手数

      def king_moved_counter
        @king_moved_counter ||= 0
      end

      def king_place
        @king_place ||= king_soldier&.place
      end

      def king_place_update
        @king_place = king_soldier&.place
      end

      def used_piece_counts
        @used_piece_counts ||= Hash.new(0)
      end

      ################################################################################

      # 大駒コンプリートしている？
      def strong_piece_completed?
        strong_piece_have_count >= STRONG_PIECE_ALL_COUNT
      end

      # 大駒の数
      def strong_piece_have_count
        Piece.strong_pieces.sum do |e|
          piece_box.fetch(e.key, 0) + board.specific_piece_count_for(location.key, e.key)
        end
      end

      ################################################################################

      def zengoma?
        if board.location_piece_counts[opponent_player.location.key] == 1              # 盤上の相手の駒が1つ
          if opponent_player.piece_box.empty?                                          # 相手の持駒がない
            location = opponent_player.location                                        # 相手の側
            board.soldiers.one? { |e| e.piece.key == :king && e.location == location } # 相手の残りの駒が玉か？ (最後に重い処理を持ってくる)
          end
        end
      end

      ################################################################################

      # 入玉宣言時の得点合計(仮)
      def ek_score_without_cond
        soldiers_ek_score + piece_box.ek_score
      end

      # 入玉宣言時の得点合計(最終)
      def ek_score_with_cond
        # 「入玉」かつ「玉を除く駒が10毎以上相手陣に入っている」なら
        if king_soldier_entered? && many_soliders_are_in_the_opponent_area?
          ek_score_without_cond
        end
      end

      ################################################################################

      # 総合得点(先後とも正)
      def current_score
        soldiers.sum(&:abs_weight) + piece_box.score
      end

      # 圧倒的なスコアがある？
      def overwhelming_score?
        current_score >= Piece::PieceScore.sure_victory_score
      end

      ################################################################################
    end
  end
end
