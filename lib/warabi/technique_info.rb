# frozen-string-literal: true

# 判定は cold_war しか使ってない

module Warabi
  class TechniqueInfo
    include ApplicationMemoryRecord
    memory_record [
      { wars_code: nil, key: "金底の歩",     parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, not_have_anything_except_pawn: nil, cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil },
      { wars_code: nil, key: "パンツを脱ぐ", parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, not_have_anything_except_pawn: nil, cold_war: true, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil },
      { wars_code: nil, key: "腹銀",         parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, not_have_anything_except_pawn: nil, cold_war: true, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil },
      { wars_code: nil, key: "垂れ歩",       parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, not_have_anything_except_pawn: nil, cold_war: true, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil },
      { wars_code: nil, key: "遠見の角",     parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, not_have_anything_except_pawn: nil, cold_war: true, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil },
      { wars_code: nil, key: "割り打ちの銀", parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, not_have_anything_except_pawn: nil, cold_war: true, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil },
    ]

    def technique_matcher_info
      @technique_matcher_info ||= TechniqueMatcherInfo.lookup(key)
    end

    include PresetInfo::DelegateToShapeInfoMethods
    include DefenseInfo::AttackInfoSharedMethods
  end
end
