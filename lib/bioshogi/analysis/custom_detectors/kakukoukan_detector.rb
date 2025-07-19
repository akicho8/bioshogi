# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class KakukoukanDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          retval = perform_block do
            # 【条件】何かで駒を取った
            Assertion.assert { captured_soldier }

            # 【条件】序盤である
            and_cond { container.joban }

            # 【条件】角を取った
            and_cond { captured_soldier.piece.key == :bishop }

            # -1手目──

            move_hand = nil
            if hand_log = previous_hand_log(1)
              move_hand = hand_log.move_hand
            end

            # 【条件】相手が駒を動かした
            and_cond { move_hand }

            # 【条件】その駒は角だった
            and_cond { move_hand.soldier.piece.key == :bishop }

            # 【条件】その駒は何かの駒を取った (刺し違える意図があった)
            and_cond { move_hand.captured_soldier }

            # 【条件】角だった
            and_cond { move_hand.captured_soldier.piece.key == :bishop }
          end

          if retval
            # 角交換された側
            player.tag_bundle << "手得"
            player.tag_bundle << "角交換"
            tag_bundle << "手得"
            tag_bundle << "角交換"

            # 角交換した側
            opponent_player.tag_bundle << "手損"
            opponent_player.tag_bundle << "角交換"
            previous_hand_log(1).tag_bundle << "手損"
            previous_hand_log(1).tag_bundle << "角交換"
          end
        end
      end
    end
  end
end
