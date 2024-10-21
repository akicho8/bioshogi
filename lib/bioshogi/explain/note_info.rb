# frozen-string-literal: true

module Bioshogi
  module Explain
    class NoteInfo
      include ApplicationMemoryRecord
      memory_record [
        # 戦法から引っ越し

        { key: "角交換型",     parent: nil,        other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil,    not_have_pawn: nil, kill_only: true, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: 1,   hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角", op_hold_piece_eq: nil, group_key: nil,  add_to_opponent: "角交換型",     technique_matcher_info: nil, },
        { key: "手得角交換型", parent: "角交換型", other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil, group_key: nil,  add_to_opponent: nil,            technique_matcher_info: nil, },
        { key: "手損角交換型", parent: "角交換型", other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: :sente, not_have_pawn: nil, kill_only: true, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角", op_hold_piece_eq: nil, group_key: nil,  add_to_opponent: "手得角交換型", technique_matcher_info: nil, },
        { key: "2手目△6二銀戦法",  parent: nil,        other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: 2,   order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil, group_key: nil,  add_to_opponent: nil,            technique_matcher_info: nil, },

        # shape_info あり

        { key: "矢倉旧24手組",  parent: nil,       other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: 24, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil, group_key: nil,  add_to_opponent: "矢倉旧24手組", technique_matcher_info: nil, },
        { key: "矢倉新24手組",  parent: nil,       other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: 24, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil, group_key: nil,  add_to_opponent: "矢倉新24手組", technique_matcher_info: nil, },

        # パラメータがないものはあとで埋めるもの

        { key: "居飛車",    parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil, skip_if_exist_keys: "振り飛車", },
        { key: "振り飛車",  parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil, skip_if_exist_keys: "居飛車", add_to_opponent: "対振り飛車", },

        { key: "相居飛車",   },
        { key: "相振り飛車", },
        { key: "対居飛車",   },
        { key: "対振り飛車", },
        { key: "対抗形",     },

        { key: "急戦",     },
        { key: "持久戦",   },

        { key: "短手数",   },
        { key: "長手数",   },

        { key: "角不成",    trigger_piece_key: {piece_key: :bishop, promoted: false, motion: :move}, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "飛車不成",  trigger_piece_key: {piece_key: :rook,   promoted: false, motion: :move}, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },

        { key: "入玉",      trigger_piece_key: {piece_key: :king,   promoted: false, motion: :move}, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "相入玉",   },

        { key: "相居玉",   },

        ################################################################################

        ################################################################################

        { key: "大駒全ブッチ", },
        {
          key: "大駒コンプリート", parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,
          add_to_opponent: "大駒全ブッチ",
          piece_box_added_proc: -> note_info, captured_soldier {
            if captured_soldier.piece.stronger
              player.stronger_piece_completed?
              # retv = player.stronger_piece_completed?
              # # 相手にも追加
              # if retv
              #   # raise
              #   # player.opponent_player.skill_set.list_push(Explain::NoteInfo["大駒全ブッチ"])
              #   # list << note_info
              #   # skill_set.list_of(e) << note_info
              # end
              # retv
            end
          },
        },
        { key: "背水の陣", },

        ################################################################################

        {
          key: "駒柱", parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,
          every_time_proc: -> note_info {
            retv = player.board.piece_piller_by_latest_piece
            if retv
              player.opponent_player.skill_set.list_push(note_info)
            end
            retv
          },
        },

        { key: "穴熊の姿焼き", }, # 勝った方だけに入れる
        { key: "都詰め",       },
        { key: "ロケット",     },
      ]

      class_attribute :human_name, default: "備考"

      include ShapeInfoRelation
      include TechAccessor
      include StyleAccessor
    end
  end
end
