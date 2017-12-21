# frozen-string-literal: true

require_relative "teaiwari_info"
require "tree_support"

module Bushido
  class DefenseInfo
    include ApplicationMemoryRecord
    memory_record [
      {wars_code: "000",  key: "カニ囲い",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-88.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/kanigakoi.html",            wikipedia_url: "https://ja.wikipedia.org/wiki/%E3%82%AB%E3%83%8B%E5%9B%B2%E3%81%84"},
      {wars_code: "001",  key: "金矢倉",           parent: nil,              other_parents: nil,      alias_names: "矢倉囲い", turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "基本的な囲い",       sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-89.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/kinyagura.html",            wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84"},
      {wars_code: "002",  key: "銀矢倉",           parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-90.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/ginyagura.html",            wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84#.E9.8A.80.E7.9F.A2.E5.80.89"},
      {wars_code: "003",  key: "片矢倉",           parent: nil,              other_parents: nil,      alias_names: "天野矢倉", turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-91.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/katayagura.html",           wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84#.E7.89.87.E7.9F.A2.E5.80.89"},
      {wars_code: "004",  key: "総矢倉",           parent: "金矢倉",         other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-92.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/souyagura.html",            wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84#.E7.B7.8F.E7.9F.A2.E5.80.89"},
      {wars_code: "005",  key: "矢倉穴熊",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-93.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/yaguraanaguma.html",        wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84#.E7.9F.A2.E5.80.89.E7.A9.B4.E7.86.8A"},
      {wars_code: "006",  key: "菊水矢倉",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-94.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/kikusuiyagura.html",        wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84#その他"},
      {wars_code: "007",  key: "銀立ち矢倉",       parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-95.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/gindatiyagura.html",        wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84#その他"},
      {wars_code: "008",  key: "菱矢倉",           parent: "金矢倉",         other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-96.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/hisiyagura.html",           wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84#その他"},
      {wars_code: "009",  key: "雁木囲い",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",       sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-97.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/ganngi.html",               wikipedia_url: "https://ja.wikipedia.org/wiki/%E9%9B%81%E6%9C%A8%E5%9B%B2%E3%81%84"},
      {wars_code: "010",  key: "ボナンザ囲い",     parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",       sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-98.html",  siratama_url: nil,                                                                                     wikipedia_url: "https://ja.wikipedia.org/wiki/Bonanza#%E3%83%9C%E3%83%8A%E3%83%B3%E3%82%B6%E5%9B%B2%E3%81%84"},
      {wars_code: "100",  key: "美濃囲い",         parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-99.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/minokakoi.html",         wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84"},
      {wars_code: "101",  key: "高美濃囲い",       parent: "美濃囲い",       other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-99.html",  siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/takaminokakoi.html",     wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84#美濃囲いの派生形・変形"},
      {wars_code: "102",  key: "銀冠",             parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-101.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/ginkannmuri.html",       wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84#美濃囲いの派生形・変形"},
      {wars_code: "103",  key: "銀美濃",           parent: "片美濃囲い",     other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-102.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/ginmino.html",           wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84#美濃囲いの派生形・変形"},
      {wars_code: "104",  key: "ダイヤモンド美濃", parent: "美濃囲い",       other_parents: "銀美濃", alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-103.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/daiyamondomino.html",    wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84#美濃囲いの派生形・変形"},
      {wars_code: "105",  key: "木村美濃",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-104.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/kimuramino.html",        wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84#美濃囲いの派生形・変形"},
      {wars_code: "106",  key: "片美濃囲い",       parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-105.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/kataminokakoi.html",     wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84#美濃囲いの派生形・変形"},
      {wars_code: "107",  key: "ちょんまげ美濃",   parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-106.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/tyonmagemino.html",      wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84#美濃囲いの派生形・変形"},
      {wars_code: "108",  key: "坊主美濃",         parent: "ちょんまげ美濃", other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-107.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/tyonmagemino.html",      wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%BE%8E%E6%BF%83%E5%9B%B2%E3%81%84#美濃囲いの派生形・変形"},
      {wars_code: "200",  key: "左美濃",           parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-108.html", siratama_url: nil,                                                                                     wikipedia_url: "https://ja.wikipedia.org/wiki/%E5%B7%A6%E7%BE%8E%E6%BF%83"},
      {wars_code: "201",  key: "天守閣美濃",       parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-109.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/tennsyukakumino.html",      wikipedia_url: "https://ja.wikipedia.org/wiki/%E5%B7%A6%E7%BE%8E%E6%BF%83#.E5.9B.B2.E3.81.84.E6.96.B9.E3.81.AE.E3.83.90.E3.83.AA.E3.82.A8.E3.83.BC.E3.82.B7.E3.83.A7.E3.83.B3"},
      {wars_code: "202",  key: "四枚美濃",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "美濃囲い変化形",     sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-110.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/yonmaimino.html",        wikipedia_url: "https://ja.wikipedia.org/wiki/%E5%B7%A6%E7%BE%8E%E6%BF%83#.E5.9B.B2.E3.81.84.E6.96.B9.E3.81.AE.E3.83.90.E3.83.AA.E3.82.A8.E3.83.BC.E3.82.B7.E3.83.A7.E3.83.B3"},
      {wars_code: "203",  key: "端玉銀冠",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "美濃囲い変化形",     sankou_url: "http://mudasure.com/blog-entry-26.html",               siratama_url: nil,                                                                                     wikipedia_url: "https://ja.wikipedia.org/wiki/%E5%B7%A6%E7%BE%8E%E6%BF%83#.E5.9B.B2.E3.81.84.E6.96.B9.E3.81.AE.E3.83.90.E3.83.AA.E3.82.A8.E3.83.BC.E3.82.B7.E3.83.A7.E3.83.B3"},
      {wars_code: "204",  key: "串カツ囲い",       parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "穴熊変化形",         sankou_url: "http://mudasure.com/blog-entry-27.html",               siratama_url: nil,                                                                                     wikipedia_url: "https://ja.wikipedia.org/wiki/%E4%B8%B2%E3%82%AB%E3%83%84%E5%9B%B2%E3%81%84"},
      {wars_code: "300",  key: "舟囲い",           parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "基本的な囲い",       sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-111.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/funagakoi.html",            wikipedia_url: "https://ja.wikipedia.org/wiki/%E8%88%9F%E5%9B%B2%E3%81%84"},
      {wars_code: "301",  key: "居飛車穴熊",       parent: nil,              other_parents: nil,      alias_names: "イビ穴",   turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "基本的な囲い",       sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-112.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/anaguma.html",              wikipedia_url: "https://ja.wikipedia.org/wiki/%E5%B1%85%E9%A3%9B%E8%BB%8A%E7%A9%B4%E7%86%8A"},
      {wars_code: "302",  key: "松尾流穴熊",       parent: "居飛車穴熊",     other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "穴熊変化形",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-113.html", siratama_url: nil,                                                                                     wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%A9%B4%E7%86%8A%E5%9B%B2%E3%81%84#.E3.83.90.E3.83.AA.E3.82.A8.E3.83.BC.E3.82.B7.E3.83.A7.E3.83.B3"},
      {wars_code: "303",  key: "銀冠穴熊",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "穴熊変化形",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-114.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/ginkanmurianaguma.html", wikipedia_url: ""},
      {wars_code: "304",  key: "ビッグ４",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "穴熊変化形",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-115.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/big4.html",                 wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%A9%B4%E7%86%8A%E5%9B%B2%E3%81%84#.E3.83.90.E3.83.AA.E3.82.A8.E3.83.BC.E3.82.B7.E3.83.A7.E3.83.B3"},
      {wars_code: "305",  key: "箱入り娘",         parent: "舟囲い",         other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "穴熊変化形",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-116.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/hakoirimusume.html",        wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%AE%B1%E5%85%A5%E3%82%8A%E5%A8%98_(%E5%B0%86%E6%A3%8B)"},
      {wars_code: "306",  key: "ミレニアム囲い",   parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "穴熊変化形",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-117.html", siratama_url: nil,                                                                                     wikipedia_url: "https://ja.wikipedia.org/wiki/%E3%83%9F%E3%83%AC%E3%83%8B%E3%82%A2%E3%83%A0%E5%9B%B2%E3%81%84"},
      {wars_code: "400",  key: "振り飛車穴熊",     parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "穴熊変化形",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-118.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/anaguma.html",           wikipedia_url: "https://ja.wikipedia.org/wiki/%E6%8C%AF%E3%82%8A%E9%A3%9B%E8%BB%8A%E7%A9%B4%E7%86%8A"},
      {wars_code: "401",  key: "右矢倉",           parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "矢倉変化系",         sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-119.html", siratama_url: nil,                                                                                     wikipedia_url: "https://ja.wikipedia.org/wiki/%E7%9F%A2%E5%80%89%E5%9B%B2%E3%81%84#その他"},
      {wars_code: "402",  key: "金無双",           parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "振り飛車", defense_group_info: "基本的な囲い",       sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-120.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/furibisya/kinmusou.html",          wikipedia_url: "https://ja.wikipedia.org/wiki/%E9%87%91%E7%84%A1%E5%8F%8C"},
      {wars_code: "403",  key: "中住まい",         parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-121.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/nakazumai.html",            wikipedia_url: "https://ja.wikipedia.org/wiki/%E4%B8%AD%E4%BD%8F%E3%81%BE%E3%81%84"},
      {wars_code: "404",  key: "中原玉",           parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-122.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/nakaharagakoi.html",        wikipedia_url: "https://ja.wikipedia.org/wiki/%E4%B8%AD%E5%8E%9F%E5%9B%B2%E3%81%84"},
      {wars_code: "500",  key: "アヒル囲い",       parent: nil,              other_parents: nil,      alias_names: "金開き",   turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "自陣全体を守る囲い", sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-123.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/kinnbiraki.html",           wikipedia_url: "https://ja.wikipedia.org/wiki/%E5%B0%86%E6%A3%8B%E3%81%AE%E6%88%A6%E6%B3%95%E4%B8%80%E8%A6%A7"},
      {wars_code: "501",  key: "いちご囲い",       parent: nil,              other_parents: nil,      alias_names: nil,        turn_limit: nil, turn_eq: nil,  teban_eq: nil, fuganai: false, kill_only: nil, stroke_only: nil, gentei_match_any: nil, fu_igai_mottetara_dame: nil, kaisenmae: nil, hold_piece_not_in: nil, hold_piece_in: nil, hold_piece_count_eq: nil, hold_piece_eq: nil, triggers: nil,  sect_key: "居飛車",   defense_group_info: "その他の囲い",       sankou_url: "http://mijinko83.blog110.fc2.com/blog-entry-124.html", siratama_url: "http://www5e.biglobe.ne.jp/~siratama/nonframe/syougi/ibisya/ichigogakoi.html",          wikipedia_url: "https://ja.wikipedia.org/wiki/%E5%B0%86%E6%A3%8B%E3%81%AE%E6%88%A6%E6%B3%95%E4%B8%80%E8%A6%A7"},
    ]

    include TeaiwariInfo::DelegateToShapeInfoMethods

    concerning :AttackInfoSharedMethods do
      included do
        include TreeSupport::Treeable
        include TreeSupport::Stringify
      end

      class_methods do
        # ["ポンポン桂"].name # => "ポンポン桂"
        # ["富沢キック"].name # => "ポンポン桂"
        def lookup(v)
          super || other_table[v]
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

      def triggers
        if super
          Array(super).collect do |e|
            Soldier.from_str(e)
          end
        end
      end

      def hold_piece_eq
        if v = super
          @hold_piece_eq ||= Utils.hold_pieces_s_to_a(v)
        end
      end

      def hold_piece_in
        if v = super
          @hold_piece_in ||= Utils.hold_pieces_s_to_a(v)
        end
      end

      def hold_piece_not_in
        if v = super
          @hold_piece_not_in ||= Utils.hold_pieces_s_to_a(v)
        end
      end

      def gentei_match_any
        if super
          Array(super).collect do |e|
            Soldier.from_str(e)
          end
        end
      end

      # def self_check
      #   if process_ki2
      #     info = Parser.parse(process_ki2)
      #     names = info.mediator.players.flat_map do |e|
      #       (e.defense_infos + e.attack_infos).collect(&:name)
      #     end
      #     if names.include?(name)
      #       names
      #     end
      #   end
      # end

      def tactic_info
        TacticInfo.fetch(tactic_key)
      end
    end

    def tactic_key
      :defense
    end
  end
end
