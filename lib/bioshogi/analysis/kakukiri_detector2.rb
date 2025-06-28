# frozen-string-literal: true

module Bioshogi
  module Analysis
    class KakukiriDetector2
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        perform_block do
          # 違う場合
          # 同角 ← -2手目 歩捕獲
          # 同角 ← -1手目 角捕獲 大駒をとった
          # 同銀 ←  0手目 角捕獲 大駒をとった
          #
          # 成立する場合
          # 同角 ← -2手目 歩捕獲
          # 同角 ← -1手目 角捕獲 大駒をとった
          # 同銀 ←  0手目 角捕獲 大駒をとった

          # 【必要条件】駒を取った
          Assertion.assert { captured_soldier }

          # 【必要条件】大駒だった
          and_cond { captured_soldier.piece.hisyakaku }

          # -1手目──

          m = nil
          if hand_log = container.hand_logs[-1]
            m = hand_log.move_hand
          end

          # 【必要条件】相手が駒を動かした
          and_cond { m }

          # 【必要条件】その駒は何かの駒を取った (刺し違える意図があった)
          and_cond { m.captured_soldier }

          # 【必要条件】大駒だった
          and_cond { m.captured_soldier.piece.hisyakaku }

          # -2手目──

          m = nil
          if hand_log = container.hand_logs[-2]
            m = hand_log.move_hand
          end

          # 【必要条件】相手が駒を動かした
          and_cond { m }

          # 【必要条件】その駒は何かの駒を取った (刺し違える意図があった)
          and_cond { m.captured_soldier }

          # 【必要条件】小駒だった
          and_cond { m.captured_soldier.piece.yowai }

          # 【必要条件】捕獲した駒は自分より弱い (相手は弱い駒と大駒を刺し違えた)
          # and_cond { m.jibunyori_yowai_komawo_totta? }

          # 55から73に角を切って馬になったとき切ったのは角だから移動元の駒を見る
          # tag = m.origin_soldier.xxx_kiri
          # hand_log.tag_bundle << tag
          # opponent_player.tag_bundle << tag
        end
      end
    end
  end
end
