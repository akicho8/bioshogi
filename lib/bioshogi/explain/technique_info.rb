# frozen-string-literal: true

# 判定は kill_count_lteq, pawn_bishop_have_ok: nil, :pawn_have_ok しか使ってない

module Bioshogi
  module Explain
    class TechniqueInfo
      include ApplicationMemoryRecord
      memory_record [
        { wars_code: nil, key: "金底の歩",     trigger_piece_key: { piece_key: :pawn,   promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "パンツを脱ぐ", trigger_piece_key: { piece_key: :knight, promoted: false, motion: :move }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "腹銀",         trigger_piece_key: { piece_key: :silver, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "垂れ歩",       trigger_piece_key: { piece_key: :pawn,   promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "遠見の角",     trigger_piece_key: { piece_key: :bishop, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "割り打ちの銀", trigger_piece_key: { piece_key: :silver, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "桂頭の銀",     trigger_piece_key: { piece_key: :silver, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "ロケット",     trigger_piece_key: { piece_key: :lance,  promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "ふんどしの桂", trigger_piece_key: { piece_key: :knight, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "継ぎ桂",       trigger_piece_key: { piece_key: :knight, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "銀冠の小部屋", trigger_piece_key: nil,                                                    parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { wars_code: nil, key: "幽霊角",       trigger_piece_key: nil,                                                    parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
      ]

      include ShapeInfoRelation
      include TechAccessor
      include StyleAccessor
    end
  end
end
