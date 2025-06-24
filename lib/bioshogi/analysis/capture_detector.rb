# frozen-string-literal: true

module Bioshogi
  module Analysis
    class CaptureDetector
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "全駒",
          func: -> {
            # 【必要条件】相手が玉単騎である
            and_cond { opponent_player.bare_king? }
          },
        },
        {
          key: "大駒コンプリート",
          func: -> {
            # 【必要条件】取った駒が飛角である
            and_cond { captured_soldier.piece.strong }

            # 【必要条件】持駒を含めて大駒をすべて持っている
            and_cond { player.strong_piece_completed? }
          },
        },
        {
          key: "歩偏執者",
          func: -> {
            # 【却下条件】取った駒は歩である
            and_cond { captured_soldier.piece.key == :pawn }

            # 【却下条件】すでに持っている
            skip_if { player.tag_bundle.has_tag?(:"歩偏執者") }

            # 【却下条件】敵が歩を持っている
            skip_if { opponent_player.piece_box.has_key?(:pawn) }

            # 【必要条件】盤上に敵の歩が一枚もない
            and_cond { opponent_player.soldiers_lookup(:pawn).empty?  }
          },
        },
      ]
    end
  end
end
