# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class MagicSquareDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          perform_block do
            # 【条件】自玉が1つ存在する
            and_cond { player.king_soldier_only_one_exist? }

            # 【条件】自玉のまわりが歩より高い価値の味方で囲まれている
            and_cond do
              basic_weight = Piece[:pawn].basic_weight
              V.outer_vectors.all? do |e|
                if v = player.king_soldier.relative_move_to(e)
                  if s = board[v]
                    s.relative_weight > basic_weight
                  end
                end
              end
            end

            tag_add("魔方陣")
          end
        end
      end
    end
  end
end
