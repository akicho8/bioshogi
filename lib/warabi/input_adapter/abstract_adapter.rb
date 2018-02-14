# frozen-string-literal: true
#
# >> |------------+----------+-------+------+-------+-------------+--------------+------------+----------+----------+--------+----------------+-------------------+------------------+------------+--------+----------+---------------------|
# >> | source     | triangle | absolute_point | same | piece | ki2_motion_part | kif_trigger_part | point_from | csa_sign | csa_from | csa_to | csa_basic_name | csa_promoted_name | usi_direct_piece | usi_direct_trigger | usi_to | usi_from | usi_promote_trigger |
# >> |------------+----------+-------+------+-------+-------------+--------------+------------+----------+----------+--------+----------------+-------------------+------------------+------------+--------+----------+---------------------|
# >> | ６八銀左   |          | ６八  |      | 銀    | 左          |              |            |          |          |        |                |                   |                  |            |        |          |                     |
# >> | △６八全   | △       | ６八  |      | 全    |             |              |            |          |          |        |                |                   |                  |            |        |          |                     |
# >> | △６八銀成 | △       | ６八  |      | 銀    |             | 成           |            |          |          |        |                |                   |                  |            |        |          |                     |
# >> | △６八銀打 | △       | ６八  |      | 銀    |             | 打           |            |          |          |        |                |                   |                  |            |        |          |                     |
# >> | △同銀     | △       |       | 同   | 銀    |             |              |            |          |          |        |                |                   |                  |            |        |          |                     |
# >> | △同銀成   | △       |       | 同   | 銀    |             | 成           |            |          |          |        |                |                   |                  |            |        |          |                     |
# >> | ７六歩(77) |          | ７六  |      | 歩    |             |              | (77)       |          |          |        |                |                   |                  |            |        |          |                     |
# >> | 7677FU     |          |       |      |       |             |              |            |          |       76 |     77 | FU             |                   |                  |            |        |          |                     |
# >> | -7677FU    |          |       |      |       |             |              |            | -        |       76 |     77 | FU             |                   |                  |            |        |          |                     |
# >> | +0077RY    |          |       |      |       |             |              |            | +        |       00 |     77 |                | RY                |                  |            |        |          |                     |
# >> | 8c8d       |          |       |      |       |             |              |            |          |          |        |                |                   |                  |            | 8d     | 8c       |                     |
# >> | P*2f       |          |       |      |       |             |              |            |          |          |        |                |                   | P                | *          | 2f     |          |                     |
# >> | 4e5c+      |          |       |      |       |             |              |            |          |          |        |                |                   |                  |            | 5c     | 4e       | +                   |
# >> |------------+----------+-------+------+-------+-------------+--------------+------------+----------+----------+--------+----------------+-------------------+------------------+------------+--------+----------+---------------------|

module Warabi
  module InputAdapter
    class AbstractAdapter
      class << self
        def run(*args)
          new(*args).tap do |e|
            e.pre_parse
            e.perform_validations
          end
        end
      end

      attr_reader :player
      attr_reader :input

      delegate :board, to: :player

      def initialize(player, input)
        @player = player
        @input = input
      end

      def pre_parse
      end

      def perform_validations
        if promoted && direct_trigger
          raise PromotedPiecePutOnError, "成った状態の駒を打つことはできません"
        end
      end

      def to_h
        {
          point_from: point_from,
          point: point,
          piece: piece,
          promoted: promoted,
          promote_trigger: promote_trigger,
          direct_trigger: direct_trigger,
        }
      end
    end
  end
end
