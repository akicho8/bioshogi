# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class KakunihakakuDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          perform_block do
            # 現在──自分が角を取った

            # 【条件】何かで駒を取った
            Assertion.assert { captured_soldier }

            # 【条件】馬か角を取った (取り返した)
            and_cond { captured_soldier.piece.key == :bishop }

            p ["#{__FILE__}:#{__LINE__}", __method__, "現在", soldier]

            # 1手前──相手が角交換してきた

            m1 = nil
            if hand_log1 = previous_hand_log(1)
              m1 = hand_log1.move_hand
            end

            # 【条件】相手が操作した
            and_cond { m1 }

            p ["#{__FILE__}:#{__LINE__}", __method__, "1手前", hand_log1.soldier]

            # 【条件】その駒は角か馬だった
            and_cond { m1.soldier.piece.key == :bishop }

            # 【条件】その駒は何かの駒を取った (刺し違える意図があった)
            and_cond { m1.captured_soldier }

            # 【条件】角 or 飛
            and_cond { m1.captured_soldier.piece.hisyakaku && m1.captured_soldier.normal? }

            # 【条件】「同*」である
            and_cond { m1.soldier.place == soldier.place }

            # 2手前──自分が生角または生飛車を打った

            d2 = nil
            if hand_log2 = previous_hand_log(2)
              d2 = hand_log2.drop_hand # 打った
            end

            # 【条件】操作した
            and_cond { d2 }

            # 【条件】角打または飛打ちだった
            and_cond { d2.soldier.piece.hisyakaku }

            # 【条件】打った場所は今、角か馬を取り返した場所と同じである
            and_cond { d2.soldier.place == soldier.place }

            # 2手前に入れる
            tag = "#{m1.origin_soldier.any_name}には#{d2.soldier.any_name}".gsub("飛", "飛車")
            hand_log2.tag_bundle << tag
            player.tag_bundle << tag
          end
        end
      end
    end
  end
end
