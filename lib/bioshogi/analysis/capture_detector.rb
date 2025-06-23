# frozen-string-literal: true

# :OPTIONAL: は考慮する必要があるもの。

module Bioshogi
  module Analysis
    class CaptureDetector
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "全駒",
          func: -> {
            and_cond do
              player.zengoma?
            end
          },
        },
        {
          key: "大駒コンプリート",
          func: -> {
            and_cond do
              if captured_soldier.piece.strong
                player.strong_piece_completed?
              end
            end
          },
        },
        {
          key: "歩偏執者",
          func: -> {
            # 【却下条件】取った駒は歩である
            and_cond { captured_soldier.piece.key == :pawn }

            # 【却下条件】すでに持っている
            skip_if { player.tag_bundle.has_tag?(TagIndex.fetch("歩偏執者")) }

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
