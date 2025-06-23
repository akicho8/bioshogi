# frozen-string-literal: true

module Bioshogi
  module Analysis
    class NoteInfo
      include ApplicationMemoryRecord
      memory_record attr_reader: TagColumnNames do
        [
          # 戦法から引っ越し
          # 「角交換型」と「手損角交換型」には shape_info あり

          { key: "角交換型",         parent: nil,        related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil,    not_have_pawn: nil, kill_only: true, drop_only: nil,  pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: 1,   hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角", op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: "角交換型",     motion_detector: nil, },
          { key: "手得角交換型",     parent: "角交換型", related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil,  pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: nil,            motion_detector: nil, },
          { key: "手損角交換型",     parent: "角交換型", related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: :order_first, not_have_pawn: nil, kill_only: true, drop_only: nil,  pawn_have_ok: nil,  outbreak_skip: true, kill_count_lteq: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角", op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: "手得角交換型", motion_detector: nil, },

          # shape_info あり

          { key: "矢倉旧24手組",     parent: nil,        related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: 24, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil,  pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: "矢倉旧24手組", motion_detector: nil,     },
          { key: "矢倉新24手組",     parent: nil,        related_ancestors: nil,  alias_names: nil, turn_limit: nil, turn_eq: 24, order_key: nil,    not_have_pawn: nil, kill_only: nil,  drop_only: nil,  pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: 0, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  op_hold_piece_eq: nil,   add_to_self: nil, add_to_opponent: "矢倉新24手組", motion_detector: nil,     },

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

          { key: "穴熊",       },
          { key: "対穴熊",     },
          { key: "相穴熊",     },

          ################################################################################

          {
            key: "全駒",
            add_to_opponent: "玉単騎",
            if_capture_then: -> {
              and_cond do
                player.zengoma?
              end
            },
          },
          { key: "玉単騎", },

          ################################################################################

          {
            key: "大駒コンプリート",
            add_to_opponent: "大駒全ブッチ",
            if_capture_then: -> {
              and_cond do
                if captured_soldier.piece.strong
                  player.strong_piece_completed?
                end
              end
            },
          },
          { key: "大駒全ブッチ", },

          { key: "屍の舞", },

          ################################################################################

          {
            key: "駒柱",
            add_to_opponent: "駒柱",
            if_true_then: -> {
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
      end

      class_attribute :human_name, default: "備考"

      include TagBase
    end
  end
end
