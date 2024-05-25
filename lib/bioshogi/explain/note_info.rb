# frozen-string-literal: true

module Bioshogi
  module Explain
    class NoteInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "入玉",      trigger_piece_key: {piece_key: :king,   promoted: false, motion: :move}, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "角不成",    trigger_piece_key: {piece_key: :bishop, promoted: false, motion: :move}, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "飛車不成",  trigger_piece_key: {piece_key: :rook,   promoted: false, motion: :move}, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },

        { key: "居飛車",    parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil, skip_if_exist_keys: "振り飛車", },
        { key: "振り飛車",  parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil, skip_if_exist_keys: "居飛車",   },

        # トリガーはもっていないシリーズ
        { key: "大駒全消失",         parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },

        # 最後に埋めるシリーズ

        { key: "相入玉",   },
        { key: "相居玉",   },
        { key: "背水の陣", },

        { key: "相居飛車", },
        { key: "対振り",   },
        { key: "相振り",   },
        { key: "対抗型",   },

        { key: "急戦",     },
        { key: "持久戦",   },

        { key: "短手数",   },
        { key: "長手数",   },

        {
          key: "大駒コンプリート", parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,
          piece_box_added_proc: -> note_info, captured_soldier {
            if captured_soldier.piece.stronger
              retv = player.stronger_piece_completed?

              # 相手にも追加
              if retv
                player.opponent_player.skill_set.list_push(Explain::NoteInfo["大駒全消失"])
                # list << note_info
                # skill_set.list_of(e) << note_info
              end

              retv
            end
          },
        },

        {
          key: "駒柱", parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,
          every_time_proc: -> note_info {
            retv = player.board.piece_piller_by_latest_piece
            if retv
              player.opponent_player.skill_set.list_push(note_info)
            end
            retv
          },
        },
      ]

      include ShapeInfoRelation
      include TechAccessor
    end
  end
end
