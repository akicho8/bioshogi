# frozen-string-literal: true

module Bioshogi
  module InputAdapter
    class SfenAdapter < AbstractAdapter
      include OriginSoldierMethods
      include SharedValidation

      def piece
        if drop_trigger
          Piece.fetch(input[:sfen_drop_piece])
        else
          origin_soldier.piece
        end
      end

      def promoted
        if drop_trigger
          false
        else
          origin_soldier.promoted || promote_trigger
        end
      end

      def place_from
        if v = input[:sfen_from]
          Place.fetch(alpha_to_digit(v))
        end
      end

      def place
        Place.fetch(alpha_to_digit(input[:sfen_to]))
      end

      def drop_trigger
        !!input[:sfen_drop_trigger]
      end

      def promote_trigger
        !!input[:sfen_promote_trigger]
      end

      def hard_validations
        super

        if drop_trigger
          unless player.piece_box.exist?(piece)
            errors_add HoldPieceNotFound, "#{piece}を打とうとしましたが#{piece}を持っていません"
          end
        end
      end

      private

      def alpha_to_digit(s)
        s.gsub(/[[:lower:]]/) { |s| s.ord - "a".ord + 1 }
      end
    end
  end
end
