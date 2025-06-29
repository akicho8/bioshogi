# frozen-string-literal: true

module Bioshogi
  module Analysis
    class MagicSquareDetector
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        perform_block do
          # 【条件】自玉が存在する
          and_cond { player.king_soldier }

          # 【条件】自玉のまわりが味方で囲まれている
          and_cond do
            V.outer_vectors.all? do |e|
              if v = player.king_soldier.relative_move_to(e)
                if s = board[v]
                  own?(s)
                end
              end
            end
          end

          tag_add(:"魔方陣")
        end
      end
    end
  end
end
