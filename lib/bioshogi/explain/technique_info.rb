# frozen-string-literal: true

# 判定は kill_count_lteq, pawn_bishop_have_ok: nil, :pawn_have_ok しか使ってない

module Bioshogi
  module Explain
    class TechniqueInfo
      # ROCKET_TRIGGERS = [
      #   { piece_key: :lance, promoted: false, motion: :drop },
      #   { piece_key: :rook,  promoted: false, motion: :both },
      #   { piece_key: :rook,  promoted: true,  motion: :both },
      # ]

      include ApplicationMemoryRecord
      memory_record [
        # { key: "たたきの歩",   trigger_piece_key: { piece_key: :pawn,   promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "継ぎ歩",       trigger_piece_key: { piece_key: :pawn,   promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "連打の歩",     trigger_piece_key: { piece_key: :pawn,   promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "垂れ歩",       trigger_piece_key: { piece_key: :pawn,   promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "金底の歩",     trigger_piece_key: { piece_key: :pawn,   promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "こびん攻め",   trigger_piece_key: { piece_key: :pawn,   promoted: false, motion: :both }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "一間竜",       trigger_piece_key: { piece_key: :rook,   promoted: true,  motion: :move }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "位の確保",     trigger_piece_key: { piece_key: :silver, promoted: false, motion: :move }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "腹銀",         trigger_piece_key: { piece_key: :silver, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "尻銀",         trigger_piece_key: { piece_key: :silver, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "割り打ちの銀", trigger_piece_key: { piece_key: :silver, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "たすきの銀",   trigger_piece_key: { piece_key: :silver, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "たすきの角",   trigger_piece_key: { piece_key: :bishop, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "桂頭の銀",     trigger_piece_key: { piece_key: :silver, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "歩頭の桂",     trigger_piece_key: { piece_key: :knight, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "田楽刺し",     trigger_piece_key: { piece_key: :lance,  promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "継ぎ桂",       trigger_piece_key: { piece_key: :knight, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "ふんどしの桂", trigger_piece_key: { piece_key: :knight, promoted: false, motion: :drop }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "パンツを脱ぐ", trigger_piece_key: { piece_key: :knight, promoted: false, motion: :move }, parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: 0,    hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "銀冠の小部屋", trigger_piece_key: nil,                                                    parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "幽霊角",       trigger_piece_key: nil,                                                    parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: nil,  pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "遠見の角",     trigger_piece_key: nil,                                                    parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: true, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: nil,  kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "土下座の歩",   trigger_piece_key: nil,                                                    parent: nil, other_parents: nil, alternate_name: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil, kill_only: nil, drop_only: true, pawn_bishop_have_ok: nil, pawn_have_ok: nil, outbreak_skip: true, kill_count_lteq: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  },
        { key: "2段ロケット",  parent: nil, },
        { key: "3段ロケット",  parent: "2段ロケット", },
        { key: "4段ロケット",  parent: "3段ロケット", },
        { key: "5段ロケット",  parent: "4段ロケット", },
        { key: "6段ロケット",  parent: "5段ロケット", },
      ]

      class_attribute :human_name, default: "手筋"

      include ShapeInfoRelation
      include TechAccessor
      include StyleAccessor

      class << self
        def rocket_list
          @rocket_list ||= values.find_all { |e| e.key.end_with?("ロケット") }
        end
      end
    end
  end
end
