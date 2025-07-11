# frozen-string-literal: true

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
            # 【条件】何かで駒を取った
            Assertion.assert { captured_soldier }

            # 【条件】飛車を取った (取り返した)
            and_cond { captured_soldier.piece.key == :rook }

            # -1手目──

            m = nil
            if hand_log = previous_hand_log(1)
              m = hand_log.move_hand
            end

            # 【条件】相手が駒を動かした
            and_cond { m }

            # 【条件】その駒は飛車だった
            and_cond { m.soldier.piece.key == :rook }

            # 【条件】その駒は何かの駒を取った (刺し違える意図があった)
            and_cond { m.captured_soldier }

            # 【条件】角だった
            and_cond { m.captured_soldier.piece.key == :bishop }

            # そうして現状はこうなっている──

            # 【条件】持駒から歩を除くと飛車しかない
            and_cond { player.piece_box.except(:pawn) == { rook: 1 } }

            # 【条件】一方相手は歩を除くと角しかない (相手の方が有利)
            and_cond { opponent_player.piece_box.except(:pawn) == { bishop: 1 } }

            tag = "序盤は飛車より角"
            hand_log.tag_bundle << tag
            opponent_player.tag_bundle << tag
          end
        end
      end
    end
  end
end
