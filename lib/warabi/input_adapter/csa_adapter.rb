# frozen-string-literal: true

module Warabi
  module InputAdapter
    class CsaAdapter < AbstractAdapter
      include LocationValidation
      include OriginSoldierMethods

      def piece
        piece_and_promoted[:piece]
      end

      def promoted
        piece_and_promoted[:promoted]
      end

      def point_from
        unless direct_trigger
          Point.fetch(input[:csa_from])
        end
      end

      def point
        Point.fetch(input[:csa_to])
      end

      # 移動元の駒との差分で「成」を判断する
      def promote_trigger
        promoted && !board.fetch(point_from).promoted
      end

      def direct_trigger
        input[:csa_from] == "00"
      end

      private

      def location_key
        :csa_sign
      end

      def piece_and_promoted
        @piece_and_promoted ||= Soldier.piece_and_promoted(input[:csa_piece])
      end
    end
  end
end
