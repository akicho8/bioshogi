# frozen-string-literal: true

# |-------------+----------------------------+----------------------------|
# |             | パターン1                  | パターン2                  |
# |-------------+----------------------------+----------------------------|
# | 1手目(自分) | 飛車切り角ゲット(角角で得) | 角切り飛車ゲット(飛飛で損) |
# | 2手目(相手) | 同歩 (飛飛で損)            | 同歩 (角角で得)            |
# |-------------+----------------------------+----------------------------|

# 序盤のロジックおよびコメントはパターン1として書いているが実際はパターン2にも当てはまる。
# 最後で分岐する。

module Bioshogi
  module Analysis
    module CustomDetectors
      class HikakukoukanDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          perform_block do
            # 0手目を相手(bob)とする

            # 【条件】何かで駒を取った
            Assertion.assert { captured_soldier }

            # 【条件】相手はしぶしぶ飛車を取った
            and_cond { captured_soldier.piece.hisyakaku }

            # 【条件】ちなみに平手風の手合割である
            and_cond { preset_is(:hirate_like) }

            # 1手前を自分(alice)とする

            m = nil
            if hand_log = previous_hand_log(1)
              m = hand_log.move_hand
            end

            # 【条件】自分は駒を動かした
            and_cond { m }

            # 【条件】その駒は次に相手が取る飛車である
            and_cond { m.soldier.piece == captured_soldier.piece }

            # 【条件】その駒は刺し違える意図があった
            and_cond { m.captured_soldier }

            # 【条件】それは角だった (captured_soldier.piece.swaped は相手が取った飛車の反対なので角)
            and_cond { m.captured_soldier.piece == captured_soldier.piece.swaped }

            # そうして現状はこうなっている──

            # 【条件】相手は持駒から歩を除くと飛車しかない
            and_cond { player.piece_box.except(:pawn) == { captured_soldier.piece.key => 1 } }

            # 【条件】一方自分は序盤で飛車を捨てて角を手持ちにした
            and_cond { opponent_player.piece_box.except(:pawn) == { captured_soldier.piece.swaped.key => 1 } }

            if captured_soldier.piece.key == :rook
              # みずから飛車と角を交換した系
              tag_define(hand_log, opponent_player, "序盤は飛車より角") # alice は飛車を切って角をゲットした
              tag_define(self, player, "序盤は角より飛車")              # 一方で bob は飛車をゲットしたが使い道がない
            else
              # ムリヤリ早石田系
              tag_define(hand_log, opponent_player, "序盤は角より飛車") # alice は飛車大好きなので角で飛車を取った
              tag_define(self, player, "序盤は飛車より角")              # alice が勝手に角飛交換してくれたので bob は角が2枚になってうれしい
            end
          end
        end

        def tag_define(object1, object2, tag)
          object1.tag_bundle << tag
          object2.tag_bundle << tag
        end
      end
    end
  end
end
