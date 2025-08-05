# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class WazaarinokeiDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          perform_block do
            # 【条件】桂成
            and_cond { soldier.piece.key == :knight && move_hand&.promote_trigger? }

            # 【却下】それによって歩以外の駒を取った場合はただの「ふんどしの桂」である
            skip_if do
              if s = captured_soldier
                s.promoted || s.piece.fuigai
              end
            end

            # 1手前──

            gold = nil
            if hand_log = previous_hand_log(1)
              gold = hand_log.move_hand
            end

            # 【条件】相手が金を動かした
            and_cond { gold && gold.soldier.piece.key == :gold }

            # 2手前──

            knight = nil
            if hand_log = previous_hand_log(2)
              knight = hand_log.hand
            end

            # 【条件】自分の桂打 (または動かした)
            and_cond { knight && knight.soldier.piece.key == :knight && knight.soldier.normal? }

            # 【条件】一方が相手の金に当たっている
            and_cond do
              V.keima_vectors.any? do |e|
                if v = knight.soldier.relative_move_to(e)
                  gold.origin_soldier.place == v
                end
              end
            end

            # 【条件】相手の金は横に移動できない (となりにいる銀が邪魔で桂成を阻止できない)
            and_cond do
              v = Place[[knight.soldier.place.column.value, gold.origin_soldier.place.row.value]]
              if s = board[v]
                s.piece.keini_yowai && s.normal? && s.location == gold.origin_soldier.location
              end
            end

            hand_log.tag_bundle << "技ありの桂"
            player.tag_bundle << "技ありの桂"
          end
        end
      end
    end
  end
end
