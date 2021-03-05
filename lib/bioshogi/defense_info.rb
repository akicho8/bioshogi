# frozen-string-literal: true

require_relative "preset_info"
require "tree_support"

require_relative "tactic_hit_turn_table"
require_relative "distribution_ratio"

module Bioshogi
  class DefenseInfo
    include ApplicationMemoryRecord
    memory_record do
      [
        { key: "カニ囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "カブト囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "金矢倉",           parent: nil,              other_parents: nil,      alias_names: "矢倉囲い",   turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        { key: "銀矢倉",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "流れ矢倉",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "四角矢倉",         parent: "銀矢倉",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "へこみ矢倉",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, description: "角換わりで表われやすいので角を持っていてもよい", },
        { key: "カタ囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "悪形矢倉",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "天野矢倉",         parent: nil,              other_parents: nil,      alias_names: "片矢倉",     turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "総矢倉",           parent: "金矢倉",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "矢倉穴熊",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "菊水矢倉",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "銀立ち矢倉",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "菱矢倉",           parent: "金矢倉",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "一文字矢倉",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "富士見矢倉",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "土居矢倉",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, description: "角は持っていてもよい", },
        { key: "蟹罐囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "オールド雁木",     parent: nil,              other_parents: nil,      alias_names: "雁木囲い",   turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "右玉",             parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,  cold_war: nil,  hold_piece_not_in: nil,  hold_piece_in: nil,  hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "糸谷流右玉",       parent: "右玉",           other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "雁木右玉",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "三段右玉",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "角換わり右玉",     parent: "右玉",           other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: "角",   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "カギ囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",         technique_matcher_info: nil, },
        { key: "ボナンザ囲い",     parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "矢倉早囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "美濃囲い",         parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "連盟美濃",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "早囲い",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, description: "別名「三手囲い」", },
        { key: "三手囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, description: "別名「三手囲い」", },
        { key: "ずれ美濃",         parent: nil,              other_parents: nil,      alias_names: "簡易囲い",   turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "振り飛車エルモ",   parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: true, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "カブト美濃",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "高美濃囲い",       parent: "美濃囲い",       other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "銀冠",             parent: "片銀冠",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "片銀冠",           parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "銀美濃",           parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "振り飛車四枚美濃", parent: "高美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: true, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "ダイヤモンド美濃", parent: "美濃囲い",       other_parents: "銀美濃", alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "木村美濃",         parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "大山美濃",         parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "裾固め",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "片美濃囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "ちょんまげ美濃",   parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "坊主美濃",         parent: "ちょんまげ美濃", other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "金美濃",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "左美濃",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "居飛車金美濃",     parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "升田美濃",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",            technique_matcher_info: nil, },
        { key: "天守閣美濃",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "四枚美濃",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "端玉銀冠",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "四枚銀冠",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        { key: "串カツ囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        { key: "舟囲い",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        { key: "舟囲いDX",         parent: "舟囲い",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        { key: "居飛車穴熊",       parent: nil,              other_parents: nil,      alias_names: "イビ穴",     turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        { key: "松尾流穴熊",       parent: "居飛車穴熊",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        { key: "銀冠穴熊",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        { key: "ビッグ４",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        { key: "箱入り娘",         parent: "舟囲い",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",         technique_matcher_info: nil, },
        { key: "金盾囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",         technique_matcher_info: nil, },
        { key: "大盾囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",         technique_matcher_info: nil, },
        { key: "ミレニアム囲い",   parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        { key: "振り飛車穴熊",     parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        { key: "振り飛車ミレニアム", parent: nil,              other_parents: nil,      alias_names: "振りミレ",          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        { key: "右矢倉",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        { key: "金無双",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        { key: "中住まい",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        { key: "中原囲い",         parent: nil,              other_parents: nil,      alias_names: "中原玉",     turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        { key: "桐山流中原囲い",   parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        { key: "アヒル囲い",       parent: nil,              other_parents: nil,      alias_names: ["金開き", "大阪囲い"],     turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        { key: "裏アヒル囲い",     parent: nil,              other_parents: nil,      alias_names: "不死鳥囲い", turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        { key: "いちご囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        { key: "無敵囲い",         parent: nil,              other_parents: nil,      alias_names: "初心者囲い", turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "エルモ囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "左山囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "無責任矢倉",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "ツノ銀雁木",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "音無しの構え",     parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "銀雲雀",           parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "あずまや囲い",     parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "セメント囲い",     parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "銀多伝",           parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "金多伝",           parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "美濃熊囲い",       parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,   cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "モノレール囲い",   parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "チョコレート囲い", parent: nil,              other_parents: nil,      alias_names: ["屋根裏矢倉", "王冠"], turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "四段端玉",         parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        { key: "空中楼閣",         parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, pawn_bishop_have_safe: nil, pawn_have_safe: nil,   cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },

      ]
    end

    include PresetInfo::DelegateToShapeInfoMethods

    concerning :AttackInfoSharedMethods do
      included do
        include TreeSupport::Treeable
        include TreeSupport::Stringify

        delegate :tactic_key, to: "self.class"
      end

      class_methods do
        # ["ポンポン桂"].name # => "ポンポン桂"
        # ["富沢キック"].name # => "ポンポン桂"
        def lookup(v)
          super || other_table[v]
        end

        def tactic_key
          @tactic_key ||= name.demodulize.underscore.remove(/_info/)
        end

        private

        def other_table
          @other_table ||= inject({}) do |a, e|
            e.alias_names.inject(a) do |a, v|
              a.merge(v => e)
            end
          end
        end
      end

      def parent
        if super
          @parent ||= self.class.fetch(super)
        end
      end

      def children
        @children ||= self.class.find_all { |e| e.parent == self }
      end

      def cached_descendants
        @cached_descendants ||= descendants
      end

      def other_parents
        @other_parents ||= Array(super).collect { |e| self.class.fetch(e) }
      end

      def alias_names
        Array(super)
      end

      def sect_info
        SectInfo.fetch(sect_key)
      end

      def urls
        v = TacticUrlsInfo[key]
        unless v
          return []
        end
        v.urls
      end

      def hold_piece_eq
        if v = super
          @hold_piece_eq ||= PieceBox.new(Piece.s_to_h(v))
        end
      end

      def hold_piece_in
        if v = super
          @hold_piece_in ||= PieceBox.new(Piece.s_to_h(v))
        end
      end

      def hold_piece_not_in
        if v = super
          @hold_piece_not_in ||= PieceBox.new(Piece.s_to_h(v))
        end
      end

      def tactic_info
        TacticInfo.fetch(tactic_key)
      end

      def technique_matcher_info
        @technique_matcher_info ||= TechniqueMatcherInfo.lookup(key)
      end

      def skip_elements
        return @skip_elements if instance_variable_defined?(:@skip_elements)

        @skip_elements = nil
        if respond_to?(:skip_if_exist_keys)
          @skip_elements = Array(skip_if_exist_keys).collect { |e| TacticInfo.flat_lookup(e) }
        end
      end

      def hit_turn
        TacticHitTurnTable[key.to_s]
      end

      def distribution_ratio
        DistributionRatio[key.to_s]
      end

      def sample_kif_file
        Pathname("#{__dir__}/#{tactic_info.name}/#{key}.kif")
      end

      # def sample_any_files
      #   Pathname("#{__dir__}/#{tactic_info.name}").glob("#{key}.{kif,ki2,csa}")
      # end
    end
  end
end
