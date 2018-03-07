# frozen-string-literal: true

module Warabi
  module InputAdapter
    class KifAdapter < AbstractAdapter
      include Ki2PlaceMethods
      include LocationValidation
      include OriginSoldierMethods
      include SharedValidation

      def piece
        piece_with_promoted[:piece]
      end

      def promoted
        piece_with_promoted[:promoted] || promote_trigger
      end

      def place_from
        Place.fetch(input[:kif_place_from].slice(/\d+/))
      end

      def promote_trigger
        !!input[:ki2_promote_trigger]
      end

      def drop_trigger
        force_drop_trigger
      end

      def hard_validations
        super

        if promoted && force_drop_trigger
          errors_add PromotedPiecePutOnError, "成った状態の駒は打てません"
        end

        # "１三金不成" と入力した場合。"１三金" の解釈になるのでスルーしてもよいが厳しくチェックする
        if have_promote_or_not_promote_force_instruction? && !piece.promotable?
          errors_add NoPromotablePiece, "#{piece}は裏がないので「成・不成・生」は指定できません"
        end

        if !promote_trigger && origin_soldier
          if origin_soldier.promoted && !promoted
            errors_add PromotedPieceToNormalPiece, "成った状態から成らない状態に戻れません"
          end
        end
      end

      private

      def force_drop_trigger
        !!input[:kif_drop_trigger]
      end

      def location_key
        :ki2_location
      end

      # 成や不成の指示があるか？
      def have_promote_or_not_promote_force_instruction?
        input[:ki2_as_it_is] || input[:ki2_promote_trigger]
      end

      def piece_with_promoted
        @piece_with_promoted ||= Soldier.piece_and_promoted(input[:kif_piece])
      end
    end
  end
end
