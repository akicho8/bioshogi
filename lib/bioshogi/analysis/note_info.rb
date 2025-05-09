# frozen-string-literal: true

module Bioshogi
  module Analysis
    class NoteInfo
      include ApplicationMemoryRecord
      memory_record [
        # 戦法から引っ越し

        { key: "角交換型",         parent: nil,        related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil,    not_have_pawn: nil, kill_only: true, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: 1,   hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角", op_hold_piece_eq: nil, group_key: nil,  add_to_self: nil, add_to_opponent: "角交換型",     technique_detector: nil, },
        { key: "手得角交換型",     parent: "角交換型", related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil, group_key: nil,  add_to_self: nil, add_to_opponent: nil,            technique_detector: nil, },
        { key: "手損角交換型",     parent: "角交換型", related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: :order_first, not_have_pawn: nil, kill_only: true, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角", op_hold_piece_eq: nil, group_key: nil,  add_to_self: nil, add_to_opponent: "手得角交換型", technique_detector: nil, },

        # shape_info あり

        { key: "矢倉旧24手組",     parent: nil,        related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: 24, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil, group_key: nil,  add_to_self: nil, add_to_opponent: "矢倉旧24手組", technique_detector: nil,     },
        { key: "矢倉新24手組",     parent: nil,        related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: 24, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil, group_key: nil,  add_to_self: nil, add_to_opponent: "矢倉新24手組", technique_detector: nil,     },

        # パラメータがないものはあとで埋めるもの

        { key: "居飛車",    parent: nil, related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil, skip_if_exist_keys: "振り飛車",  add_to_self: nil, add_to_opponent: nil,           },
        { key: "振り飛車",  parent: nil, related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil, skip_if_exist_keys: "居飛車",    add_to_self: nil, add_to_opponent: "対振り飛車",  },

        { key: "相居飛車",   },
        { key: "相振り飛車", },
        { key: "対居飛車",   },
        { key: "対振り飛車", },
        { key: "対抗形",     },

        { key: "急戦",     },
        { key: "持久戦",   },

        { key: "短手数",   },
        { key: "長手数",   },

        { key: "角不成",    trigger_piece_key: { piece_key: :bishop, promoted: false, motion: :move }, parent: nil, related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "飛車不成",  trigger_piece_key: { piece_key: :rook,   promoted: false, motion: :move }, parent: nil, related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },

        { key: "入玉",      trigger_piece_key: { piece_key: :king,   promoted: false, motion: :move }, parent: nil, related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "相入玉",   },

        { key: "相居玉",   },

        { key: "穴熊",   },
        { key: "対穴熊", },
        { key: "相穴熊", },

        ################################################################################

        {
          key: "全駒", parent: nil, related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,
          add_to_self: nil, add_to_opponent: "玉単騎",
          piece_box_added_proc: -> note_info, captured_soldier {
            player.zengoma?
          },
        },
        { key: "玉単騎", },

        ################################################################################

        {
          key: "大駒コンプリート", parent: nil, related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,
          add_to_self: nil, add_to_opponent: "大駒全ブッチ",
          piece_box_added_proc: -> note_info, captured_soldier {
            if captured_soldier.piece.strong
              player.strong_piece_completed?
            end
          },
        },
        { key: "大駒全ブッチ", },

        { key: "背水の陣", },

        ################################################################################

        {
          key: "駒柱", parent: nil, related_ancestors: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,
          add_to_self: nil, add_to_opponent: "駒柱",
          every_time_proc: -> note_info {
            player.board.piller_cop.active?.tap do
              player.board.piller_cop.active = false # FIXME: できればここで更新はしたくない
            end
          },
        },

        { key: "穴熊の姿焼き",   }, # 勝った方だけに入れる
        { key: "名人に定跡なし", }, # 定跡なしで勝ったら入れる
        { key: "都詰め",         },
        { key: "雪隠詰め",       },
        { key: "吊るし桂",       },
        { key: "ロケット",       },
      ]

      class_attribute :human_name, default: "備考"

      include ShapeInfoRelation
      include BasicAccessor
      include TreeMod
      include StaticKifMod
      include StyleAccessor
    end
  end
end
