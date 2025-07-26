module Bioshogi
  module Analysis
    TagColumnNames = [
      # 基本情報
      :group_key,
      :parent,                  # DEPLICATE
      :related_ancestors,       # DEPLICATE
      :alias_names,
      :add_to_self,
      :add_to_opponent,
      :preset_has,        # PresetInfo のなかで、この値を持つ対局だけで、有効とする
      :description,

      # shape_info 系依存だが、outbreak_skip は他のところでも使っているので完全に shape_info 系として分けるわけにもいかない
      :turn_max,
      :turn_eq,
      :order_key,
      :has_pawn_then_skip,       # 歩を持っていたらスキップ
      :has_other_pawn_then_skip, # 歩を除いて駒を持っていたらスキップ
      :kill_only,
      :drop_only,
      :outbreak_skip,
      :kill_count_lteq,
      :hold_piece_not_in,
      :hold_piece_in,
      :hold_piece_empty,
      :hold_piece_eq,
      :op_hold_piece_eq,
    ]
  end
end
