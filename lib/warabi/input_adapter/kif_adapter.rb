# frozen-string-literal: true

module Warabi
  module InputAdapter
    class KifAdapter < AbstractAdapter
      attr_reader :piece
      attr_reader :promoted

      def piece
        piece_with_promoted[:piece]
      end

      def promoted
        piece_with_promoted[:promoted] || promote_trigger
      end

      def point_from
        if v = input[:kif_point_from]
          Point.fetch(v.slice(/\d+/))
        end
      end

      def point
        absolute_point || same_point
      end

      def promote_trigger
        !!input[:ki2_promote_trigger]
      end

      def direct_trigger
        !!input[:kif_direct_trigger]
      end

      def perform_validations
        super

        # 初手に△７六歩の場合
        if location
          if player.location != location
            raise DifferentTurnError, "手番が明示されていますが実際の手番と異なります : #{player.location}の手番で#{location}が着手"
          end
        end

        # 初手に同歩の場合
        if same? && !same_point
          raise BeforePointNotFound, "同に対する座標が不明です"
        end

        # 記事などで改ページしたとき明示的に "同歩" ではなく "同２四歩" と書く場合もあるとのことで同の座標が２四ではない場合
        if same? && same_point && absolute_point
          if same_point != absolute_point
            raise SamePointDifferent, "同は#{same_point}を意味しますが明示的に指定した移動先は#{absolute_point}です"
          end
        end

        # 結局座標がわからない場合
        if !point
          raise SyntaxDefact, "移動先の座標が不明です"
        end

        # "１三金不成" と入力した場合。"１三金" の解釈になるのでスルーしてもよいが厳しくチェックする
        if have_promote_or_not_promote_force_instruction? && !piece.promotable?
          raise NoPromotablePiece, "#{piece}は裏がないので「成・不成・生」は指定できません"
        end
      end

      private

      def location
        if v = input[:ki2_location]
          Location.fetch(v)
        end
      end

      # 成や不成の指示があるか？
      def have_promote_or_not_promote_force_instruction?
        !!(input[:ki2_as_it_is] || input[:ki2_promote_trigger])
      end

      def absolute_point
        if v = input[:kif_point]
          Point.fetch(v)
        end
      end

      def same_point
        if hand_log = player.mediator.hand_logs.last
          hand_log.soldier.point
        end
      end

      def same?
        !!input[:ki2_same]
      end

      def piece_with_promoted
        @piece_with_promoted ||= Soldier.piece_and_promoted(input[:kif_piece])
      end
    end
  end
end
