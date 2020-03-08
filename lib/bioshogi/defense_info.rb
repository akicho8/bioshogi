# frozen-string-literal: true

require_relative "preset_info"
require "tree_support"

module Bioshogi
  class DefenseInfo
    include ApplicationMemoryRecord
    memory_record do
      [
        # 1
        {wars_code: "000",  key: "カニ囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: nil,    key: "カブト囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: "001",  key: "金矢倉",           parent: nil,              other_parents: nil,      alias_names: "矢倉囲い",   turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        {wars_code: "002",  key: "銀矢倉",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: nil,    key: "悪形矢倉",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: "003",  key: "片矢倉",           parent: nil,              other_parents: nil,      alias_names: "天野矢倉",   turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: "004",  key: "総矢倉",           parent: "金矢倉",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: "005",  key: "矢倉穴熊",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: "006",  key: "菊水矢倉",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: "007",  key: "銀立ち矢倉",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: "008",  key: "菱矢倉",           parent: "金矢倉",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,  cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        {wars_code: nil,    key: "蟹罐囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },

        # 2
        {wars_code: "009",  key: "雁木囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        {wars_code: "010",  key: "ボナンザ囲い",     parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        {wars_code: "011",  key: "矢倉早囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        {wars_code: "100",  key: "美濃囲い",         parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: nil,    key: "早囲い",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, description: "別名「三手囲い」", },
        {wars_code: nil,    key: "三手囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, description: "別名「三手囲い」", },
        {wars_code: nil,    key: "ずれ美濃",         parent: nil,              other_parents: nil,      alias_names: "簡易囲い",   turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: nil,    key: "カブト美濃",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "101",  key: "高美濃囲い",       parent: "美濃囲い",       other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "102",  key: "銀冠",             parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "103",  key: "銀美濃",           parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "104",  key: "ダイヤモンド美濃", parent: "美濃囲い",       other_parents: "銀美濃", alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "105",  key: "木村美濃",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: nil,    key: "裾固め",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        # 3
        {wars_code: "106",  key: "片美濃囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "107",  key: "ちょんまげ美濃",   parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "108",  key: "坊主美濃",         parent: "ちょんまげ美濃", other_parents: nil,      alias_names: "大山美濃",   turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "109",  key: "金美濃",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "200",  key: "左美濃",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "201",  key: "天守閣美濃",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "202",  key: "四枚美濃",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "203",  key: "端玉銀冠",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: nil,    key: "四枚銀冠",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     technique_matcher_info: nil, },
        {wars_code: "204",  key: "串カツ囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        # 4
        {wars_code: "300",  key: "舟囲い",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        {wars_code: "301",  key: "居飛車穴熊",       parent: nil,              other_parents: nil,      alias_names: "イビ穴",     turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        {wars_code: "302",  key: "松尾流穴熊",       parent: "居飛車穴熊",     other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        {wars_code: "303",  key: "銀冠穴熊",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        {wars_code: "304",  key: "ビッグ４",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        {wars_code: "305",  key: "箱入り娘",         parent: "舟囲い",         other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        {wars_code: "306",  key: "ミレニアム囲い",   parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        {wars_code: "400",  key: "振り飛車穴熊",     parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "穴熊変化形",         technique_matcher_info: nil, },
        {wars_code: "401",  key: "右矢倉",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "矢倉変化系",         technique_matcher_info: nil, },
        # 5
        {wars_code: "402",  key: "金無双",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "振り飛車", defense_group_info: "基本的な囲い",       technique_matcher_info: nil, },
        {wars_code: "403",  key: "中住まい",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        {wars_code: "404",  key: "中原玉",           parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        {wars_code: "500",  key: "アヒル囲い",       parent: nil,              other_parents: nil,      alias_names: "金開き",     turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        {wars_code: nil,    key: "裏アヒル囲い",     parent: nil,              other_parents: nil,      alias_names: "不死鳥囲い", turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", technique_matcher_info: nil, },
        {wars_code: "501",  key: "いちご囲い",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",       technique_matcher_info: nil, },
        {wars_code: "502",  key: "無敵囲い",         parent: nil,              other_parents: nil,      alias_names: "初心者囲い", turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },

        {wars_code: nil,    key: "elmo囲い",         parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,    key: "左山囲い",         parent: "elmo囲い",       other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,    key: "無責任矢倉",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,    key: "ツノ銀雁木",       parent: nil,              other_parents: nil,      alias_names: nil,          turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true, cold_war: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,   sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },

        {wars_code: nil,  key: "音無しの構え",     parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "銀雲雀",           parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "あずまや囲い",     parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "セメント囲い",     parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "銀多伝",           parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "金多伝",           parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "美濃熊囲い",       parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,   cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "モノレール囲い",   parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "チョコレート囲い", parent: nil,              other_parents: nil,      alias_names: ["屋根裏矢倉", "王冠"], turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "四段端玉",         parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: true,  cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },
        {wars_code: nil,  key: "空中楼閣",         parent: nil,              other_parents: nil,      alias_names: nil,                    turn_limit: nil, turn_eq: nil,  order_key: nil, sente: nil, not_have_pawn: nil, kill_only: nil, drop_only: false, not_have_anything_except_pawn: nil,   cold_war: nil,  hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_empty: nil, hold_piece_eq: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",     technique_matcher_info: nil, },

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
    end
  end
end
