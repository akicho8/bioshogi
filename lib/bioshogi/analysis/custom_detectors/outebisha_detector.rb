# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class OutebishaDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          raise <<~EOT
このロジックは、王手飛車を仕掛けた2手後に飛車を取ることを前提としており、
飛車を取った手をトリガーとして、2手前にさかのぼって当たり判定を行っている。

しかし、実際の対局では飛車をすぐに取らず、さらに王手を継続した後、
4手後などに飛車を取るケースもある。また、王手飛車をかけた時点で
相手が投了する場合もあり、その際は飛車を取る手が存在しないため、
現行のロジックでは王手飛車の判定ができない。

参考: https://www.youtube.com/shorts/uthgbYZyYLE
EOT
          perform_block do
            # 現在──自分が飛車を取った

            # 【条件】角か馬を動かした
            and_cond { soldier.piece.key == :bishop }

            # 【条件】駒を取った
            Assertion.assert { captured_soldier }

            # 【条件】飛か龍を取った
            and_cond { captured_soldier.piece.key == :rook }

            # 2手前──自分が角を打った (または移動した)

            d2 = nil
            if hand_log2 = previous_hand_log(2)
              d2 = hand_log2.hand
            end

            # 【条件】操作した
            and_cond { d2 }

            # 【条件】角を操作した
            and_cond { d2.soldier.piece.key == :bishop }

            # 【条件】その角は2手後に飛を取る (それがわかっているから、いま飛に当たっているかの判定は除外できる)
            and_cond { d2.soldier == move_hand.origin_soldier }

            # 【WIP】当たり判定
            raise "TODO: 当たり判定"
            V.saltire_vectors.each do |e|
              p e
              (1..Float::INFINITY).each do |magnification|
                if v = d2.soldier.relative_move_to(e, magnification: magnification)
                  p v
                else
                  break
                end
              end
            end

            hand_log2.tag_bundle << "王手飛車"
            player.tag_bundle << "王手飛車"
          end
        end
      end
    end
  end
end
