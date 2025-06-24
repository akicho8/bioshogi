# frozen-string-literal: true

module Bioshogi
  module Analysis
    class NoteInfo
      include ApplicationMemoryRecord
      memory_record attr_reader: TagColumnNames do
        [
          # 戦法から引っ越し
          # 「角交換型」と「手損角交換型」には shape_info あり

          { key: "角交換型",         parent: nil,        related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil,    not_have_pawn: nil, kill_only: true, drop_only: nil,  pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: 1,   hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角", op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: "角交換型",      },
          { key: "手得角交換型",     parent: "角交換型", related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil,  pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: nil,             },
          { key: "手損角交換型",     parent: "角交換型", related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: :order_first, not_have_pawn: nil, kill_only: true, drop_only: nil,  pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角", op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: "手得角交換型",  },

          # shape_info あり

          { key: "矢倉旧24手組",     parent: nil,        related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: 24, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil,  pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: "矢倉旧24手組",      },
          { key: "矢倉新24手組",     parent: nil,        related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: 24, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil,  pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: "矢倉新24手組",      },

          ################################################################################

          # パラメータがないものはあとで埋めるもの

          { key: "居飛車",    parent: nil, related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil, skip_if_exist: "振り飛車",  add_to_self: nil, add_to_opponent: nil,           },
          { key: "振り飛車",  parent: nil, related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_have_ok: nil, outbreak_skip: nil, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil, skip_if_exist: "居飛車",    add_to_self: nil, add_to_opponent: "対振り飛車",  },

          { key: "相居飛車",   },
          { key: "相振り飛車", },
          { key: "対居飛車",   },
          { key: "対振り飛車", },
          { key: "対抗形",     },

          { key: "急戦",       },
          { key: "持久戦",     },

          { key: "短手数",     },
          { key: "長手数",     },

          { key: "角不成",     }, # トリガーあり
          { key: "飛車不成",   }, # トリガーあり
          { key: "入玉",       }, # トリガーあり
          { key: "相入玉",     }, # 最後に追加する

          { key: "相居玉",     },

          { key: "相穴熊",     },
        ]
      end

      class_attribute :human_name, default: "備考"

      include TagMethods
    end
  end
end
