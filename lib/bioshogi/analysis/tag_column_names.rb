module Bioshogi
  module Analysis
    TagColumnNames = [
      # 基本情報
      :group_key,
      :parent,
      :related_ancestors,
      :alias_names,
      :add_to_self,
      :add_to_opponent,
      :preset_has,        # PresetInfo のなかで、この値を持つ対局だけで、有効とする
      :description,

      # shape_info 系依存だが、outbreak_skip は他のところでも使っているので完全に shape_info 系として分けるわけにもいかない
      :turn_limit,
      :turn_eq,
      :order_key,
      :not_have_pawn,
      :kill_only,
      :drop_only,
      :pawn_have_ok,
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
