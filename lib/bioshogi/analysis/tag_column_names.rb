module Bioshogi
  module Analysis
    TagColumnNames = [
      :trigger,
      :group_key,
      :parent,
      :related_ancestors,
      :alias_names,
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
      :add_to_self,
      :add_to_opponent,
      :tag_detector,
      :description,
      :every_time_proc,
      :preset_has,        # PresetInfo のなかで、この値を持つ対局だけで、有効とする
      :piece_box_added_proc,
      :delete_keys,
      :skip_if_exist_keys,
    ]
  end
end
