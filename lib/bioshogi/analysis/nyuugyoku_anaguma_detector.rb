# frozen-string-literal: true

module Bioshogi
  module Analysis
    class NyuugyokuAnagumaDetector
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        retv = perform_block do
          # 【条件】自玉が1つ存在する
          and_cond { player.king_soldier_only_one_exist? }

          # 【条件】自玉が隅にいる
          and_cond { king_soldier.top_spaces == 0 && king_soldier.side_edge? }

          # 【条件】動かしたまたは打った駒は銀以上の駒である
          and_cond { soldier.abs_weight >= min_score }

          # 【条件】駒は玉と同じ側である
          and_cond { soldier.left_or_right == king_soldier.left_or_right }

          # 【条件】駒は玉の近くである (2x2)
          and_cond { soldier.place.in_outer_area?(king_soldier.place, 1) }
        end

        if retv
          if soldier_count >= 3
            tag_add(:"入玉穴熊", once: true)
          end
        end
      end

      # 玉の周辺の金以上の駒の数を数える
      def soldier_count
        @soldier_count ||= yield_self do
          V.outer_vectors.count do |e|
            if v = king_soldier.relative_move_to(e)
              if s = board[v]
                if own?(s)
                  s.abs_weight >= min_score
                end
              end
            end
          end
        end
      end

      # 自玉
      def king_soldier
        @king_soldier ||= player.king_soldier
      end

      # 金以上の駒の価値
      def min_score
        @min_score ||= Piece[:gold].basic_weight
      end
    end
  end
end
