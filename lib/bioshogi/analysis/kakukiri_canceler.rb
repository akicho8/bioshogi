# frozen-string-literal: true

module Bioshogi
  module Analysis
    class KakukiriCanceler
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        perform_block do
          # 【必要条件】駒を取った
          Assertion.assert { captured_soldier }

          # 【必要条件】取った駒は強い
          and_cond { captured_soldier.piece.hisyakaku }

          # 2手前──

          m = nil
          if hand_log = container.hand_logs[-2]
            m = hand_log.move_hand
          end

          and_cond { m }

          ["飛車切り", "竜切り", "角切り", "馬切り"].each do |e|
            if hand_log.tag_bundle.has_tag?(e)
              hand_log.tag_bundle.delete_tag(e)
              # としても結局 player.tag_bundle の方から取り除かないといけない
              # player.tag_bundle に入れたものは2手前のものか判断できない
              # したがって、現在のデータ構造だと「取り消し」にはうまく対応できない
              break
            end
          end
        end
      end
    end
  end
end
