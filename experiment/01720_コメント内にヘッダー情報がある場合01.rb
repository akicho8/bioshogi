require "./example_helper"

info = Parser.parse(<<~EOT)
開始日時：2003/08/25
棋戦：ＮＨＫ杯
戦型：中飛車
備考：▲ゴキゲン中飛車位取り型
先手：畠山成幸
後手：郷田真隆

場所：ＮＨＫ放送センター
持ち時間：15分＋30秒＋10回
*放映日：2003/09/07
*棋戦詳細：第53回ＮＨＫ杯戦2回戦第05局
*「畠山成幸七段」vs「郷田真隆九段」
▲６八銀
まで138手で後手の勝ち
EOT

tp info.header.to_h
tp info.header.__to_simple_names_h
tp info.header.meta_info
tp info.header.__to_meta_h
tp info.header.to_kisen_a
tp info.header.__to_simple_names_h

info.mediator_run
tp info.header.to_h
tp info.skill_set_hash

# ~> -:21:in `<main>': undefined method `__to_simple_names_h' for #<Bioshogi::Parser::Header:0x00007fa5a4977178> (NoMethodError)
# ~> Did you mean?  to_enum
# >> |----------+--------------------------|
# >> | 開始日時 | 2003/08/25               |
# >> |     棋戦 | NHK杯                    |
# >> |     戦型 | 中飛車                   |
# >> |     備考 | ▲ゴキゲン中飛車位取り型 |
# >> |     先手 | 畠山成幸                 |
# >> |     後手 | 郷田真隆                 |
# >> |     場所 | NHK放送センター          |
# >> | 持ち時間 | 15分＋30秒＋10回         |
# >> |   放映日 | 2003/09/07               |
# >> | 棋戦詳細 | 第53回NHK杯戦2回戦第5局  |
# >> | 先手詳細 | 畠山成幸七段             |
# >> | 後手詳細 | 郷田真隆九段             |
# >> |----------+--------------------------|
