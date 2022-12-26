# frozen-string-literal: true
#
# >> |------------+--------------+-----------+----------+-----------+------------+----------------+-------------+--------------+---------------------+------------------+----------------+----------+----------+--------+-----------+----------------+------------------+--------+----------+---------------------|
# >> | source     | ki2_location | kif_place | ki2_same | kif_piece | ki2_one_up | ki2_left_right | ki2_up_down | ki2_as_it_is | ki2_promote_trigger | kif_drop_trigger | kif_place_from | csa_sign | csa_from | csa_to | csa_piece | sfen_drop_piece | sfen_drop_trigger | sfen_to | sfen_from | sfen_promote_trigger |
# >> |------------+--------------+-----------+----------+-----------+------------+----------------+-------------+--------------+---------------------+------------------+----------------+----------+----------+--------+-----------+----------------+------------------+--------+----------+---------------------|
# >> | ６八銀左上 |              | ６八      |          | 銀        |            | 左             | 上          |              |                     |                  |                |          |          |        |           |                |                  |        |          |                     |
# >> | △６八全   | △           | ６八      |          | 全        |            |                |             |              |                     |                  |                |          |          |        |           |                |                  |        |          |                     |
# >> | △６八銀成 | △           | ６八      |          | 銀        |            |                |             |              | 成                  |                  |                |          |          |        |           |                |                  |        |          |                     |
# >> | △６八銀打 | △           | ６八      |          | 銀        |            |                |             |              |                     | 打               |                |          |          |        |           |                |                  |        |          |                     |
# >> | △同銀     | △           |           | 同       | 銀        |            |                |             |              |                     |                  |                |          |          |        |           |                |                  |        |          |                     |
# >> | △同銀成   | △           |           | 同       | 銀        |            |                |             |              | 成                  |                  |                |          |          |        |           |                |                  |        |          |                     |
# >> | ７六歩(77) |              | ７六      |          | 歩        |            |                |             |              |                     |                  | (77)           |          |          |        |           |                |                  |        |          |                     |
# >> | 7677FU     |              |           |          |           |            |                |             |              |                     |                  |                |          |       76 |     77 | FU        |                |                  |        |          |                     |
# >> | -7677FU    |              |           |          |           |            |                |             |              |                     |                  |                | -        |       76 |     77 | FU        |                |                  |        |          |                     |
# >> | +0077RY    |              |           |          |           |            |                |             |              |                     |                  |                | +        |       00 |     77 | RY        |                |                  |        |          |                     |
# >> | 8c8d       |              |           |          |           |            |                |             |              |                     |                  |                |          |          |        |           |                |                  | 8d     | 8c       |                     |
# >> | P*2f       |              |           |          |           |            |                |             |              |                     |                  |                |          |          |        |           | P              | *                | 2f     |          |                     |
# >> | 4e5c+      |              |           |          |           |            |                |             |              |                     |                  |                |          |          |        |           |                |                  | 5c     | 4e       | +                   |
# >> |------------+--------------+-----------+----------+-----------+------------+----------------+-------------+--------------+---------------------+------------------+----------------+----------+----------+--------+-----------+----------------+------------------+--------+----------+---------------------|

module Bioshogi
  module InputAdapter
    class AbstractAdapter
      attr_reader :player
      attr_reader :input

      delegate :board, to: :player

      def initialize(player, input)
        @player = player
        @input = input
      end

      def perform_validations
        begin
          hard_validations
        rescue BioshogiError => error
          errors_add(error.class, error.message.lines.first.strip)
        end

        if errors.empty?
          soft_validations
        end
      end

      def errors
        @errors ||= []
      end

      def errors_add(error_class, message)
        errors << {error_class: error_class, message: message}
      end

      # 目的地に来れる盤上の駒の配列
      def candidate_soldiers
        @candidate_soldiers ||= player.candidate_soldiers(piece: piece, promoted: !promote_trigger && promoted, place: place)
      end

      def candidate_soldiers_as_string
        s = []
        s << "移動元は"
        s << candidate_soldiers.collect { |e| "「#{e.place.name}の#{e.any_name}」" }.join("か")
        s << "の"
        if candidate_soldiers.size >= 3
          s << "どれ"
        else
          s << "どっち"
        end
        s << "でしょう？"
        s.join
      end

      def soldier
        @soldier ||= Soldier.create(piece: piece, promoted: promoted, place: place, location: soldier_location)
      end

      # 移動後の駒の location は移動元の駒の location に合わせる
      # こうすることで、バリデーションをしない場合、2手目で後手は先手の駒を動かせる
      def soldier_location
        if origin_soldier
          origin_soldier.location
        else
          player.location
        end
      end

      def move_hand
        if origin_soldier
          @move_hand ||= Hand::Move.create(soldier: soldier, origin_soldier: origin_soldier, captured_soldier: board.surface[place])
        end
      end

      def drop_hand
        if !origin_soldier
          @drop_hand ||= Hand::Drop.create(soldier: soldier)
        end
      end

      def hand
        @hand ||= move_hand || drop_hand
      end

      def to_h
        {
          :place_from      => place_from,
          :place           => place,
          :piece           => piece,
          :promoted        => promoted,
          :promote_trigger => promote_trigger,
          :drop_trigger    => drop_trigger,
          :errors          => errors,
        }
      end

      private

      def hard_validations
      end

      def soft_validations
      end
    end
  end
end
