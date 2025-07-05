# frozen-string-literal: true

module Bioshogi
  module Analysis
    class HorseDetector
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        retv = perform_block do
          # 【条件】移動してきた
          and_cond { move_hand }

          # 【条件】馬である
          and_cond { soldier.piece.key == :bishop && soldier.promoted }

          # 【条件】自玉が1つ存在する
          and_cond { player.king_soldier_only_one_exist? }

          # 【条件】自玉は相手の陣地に入っていない
          and_cond { player.king_soldier.not_opp_side? }

          # 【条件】玉の近くにいる
          and_cond { near_the_king(soldier) }

          # 【却下】元から玉の近くにいる
          skip_if { near_the_king(origin_soldier) }
        end

        if retv
          if another_horse_is_near_the_king
            tag_add("双馬結界", once: true)
          else
            tag_add("守りの馬")
          end
        end
      end

      # もうひとつの馬も玉の近くにいる
      def another_horse_is_near_the_king
        soldiers = player.soldiers_lookup2(:bishop, true)
        if another_horse = (soldiers - [soldier]).first
          near_the_king(another_horse)
        end
      end

      # soldier は玉から道のりで2x2の中にいるか？
      def near_the_king(soldier)
        player.king_soldier.place.manhattan_distance(soldier.place) <= 2
      end
    end
  end
end
