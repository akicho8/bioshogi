# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class KakukiriDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          perform_block do
            # skip_if { true }

            # 【条件】駒を取った
            Assertion.assert { captured_soldier }

            # 【条件】取った駒は強い
            and_cond { captured_soldier.piece.hisyakaku }

            # 1手前──

            m = nil
            if hand_log = container.hand_logs[-1]
              m = hand_log.move_hand
            end

            # 【条件】相手が駒を動かした
            and_cond { m }

            # 【条件】その駒は今取った駒である
            and_cond { m.soldier == captured_soldier }

            # 【条件】その駒は何かの駒を取った
            and_cond { m.captured_soldier }

            # 【条件】その駒は金銀と刺し違えた
            and_cond { m.captured_soldier.piece.kingin }

            # 55から73に角を切って馬になったとき切ったのは角だから移動元の駒を見る
            tag = m.origin_soldier.xxx_kiri
            hand_log.tag_bundle << tag
            opponent_player.tag_bundle << tag
          end
        end
      end
    end
  end
end
