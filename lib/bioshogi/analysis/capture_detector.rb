# frozen-string-literal: true

module Bioshogi
  module Analysis
    class CaptureDetector
      include ApplicationMemoryRecord
      memory_record [
        # {
        #   key: "序盤は飛車より角",
        #   func: -> {
        #     # 【条件】角を取った
        #     and_cond { captured_soldier.piece.key == :bishop }
        #
        #     # 【条件】動かした駒は飛か龍
        #     and_cond { soldier.piece.key == :rook }
        #
        #     # 【条件】序盤である
        #     and_cond { container.joban }
        #   },
        # },
        {
          key: "全駒",
          func: -> {
            # 【条件】一般的な駒落ち以上とする
            and_cond { preset_is(:x_taden) }

            # 【条件】相手が玉単騎である
            and_cond { opponent_player.bare_king? }
          },
        },
        {
          key: "金銀コンプリート",
          func: -> {
            # 【条件】一般的な駒落ち以上とする
            and_cond { preset_is(:x_taden) }

            # 【条件】取った駒が金銀である
            and_cond { captured_soldier.piece.kingin }

            # 【条件】持駒を含めて金銀をすべて持っている
            and_cond { player.kingin_piece_completed? }
          },
        },
        {
          key: "大駒コンプリート",
          func: -> {
            # 【条件】一般的な駒落ち以上とする
            and_cond { preset_is(:x_taden) }

            # 【条件】取った駒が飛角である
            and_cond { captured_soldier.piece.hisyakaku }

            # 【条件】持駒を含めて大駒をすべて持っている
            and_cond { player.hisyakaku_piece_completed? }
          },
        },
        {
          key: "ポーンハンター",
          func: -> {
            # 【条件】一般的な駒落ち以上とする
            and_cond { preset_is(:x_taden) }

            # 【条件】取った駒は歩である
            and_cond { captured_soldier.piece.key == :pawn }

            # 【却下】すでに持っている
            skip_if { player.tag_bundle.include?("ポーンハンター") }

            # 【条件】歩を全部持っている
            and_cond do
              count = player.soldiers_lookup1(:pawn).size + (player.piece_box[:pawn] || 0)
              count >= PieceBox.showcase_all[:pawn]
            end
          },
        },
        {
          key: "三桂懐刃",
          description: "さんけいかいじん──懐に潜めた三つの刃＝桂馬。刺すタイミングを計る恐怖の構え。",
          func: -> {
            # 【条件】一般的な駒落ち以上とする
            and_cond { preset_is(:x_taden) }

            # 【却下】取った駒が桂である
            and_cond { captured_soldier.piece.key == :knight }

            # 【条件】3枚目の桂馬である
            and_cond { (piece_box[:knight] || 0) == 3 }
          },
        },
        {
          key: "封香連舞",
          description: "ふうこうれんぶ──香車たちは今、封じられている（手駒）──だが一たび解き放てば、連舞するがごとく攻め立てる。",
          func: -> {
            # 【条件】一般的な駒落ち以上とする
            and_cond { preset_is(:x_taden) }

            # 【却下】取った駒が香である
            and_cond { captured_soldier.piece.key == :lance }

            # 【条件】4枚目の香車である
            and_cond { (piece_box[:lance] || 0) == 4 }
          },
        },
      ]
    end
  end
end
