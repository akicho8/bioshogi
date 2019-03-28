# frozen-string-literal: true

module Warabi
  class NoteInfo
    include ApplicationMemoryRecord
    memory_record [
      { wars_code: nil, key: "入玉",             trigger_piece_key: {piece_key: :king,   promoted: false, motion: :move}, parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, not_have_anything_except_pawn: nil, cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
      { wars_code: nil, key: "大駒コンプリート", piece_box_added_func: -> captured_soldier {
          count = 0
          count += board.surface2[[player.location, Piece.fetch(:rook)]]
          count += board.surface2[[player.location, Piece.fetch(:bishop)]]
          count += piece_box[:rook] || 0
          count += piece_box[:bishop] || 0
          count >= 4
        }, parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, not_have_anything_except_pawn: nil, cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
    ]

    include PresetInfo::DelegateToShapeInfoMethods
    include DefenseInfo::AttackInfoSharedMethods
  end
end
