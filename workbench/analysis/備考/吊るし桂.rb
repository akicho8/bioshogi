require "../../setup"
info = Analysis::NoteInfo.fetch("吊るし桂").static_kif_info
tp info.formatter.container.players.collect { |e| e.skill_set.to_h }
puts info.to_kif
# >> |--------+---------+-----------+--------------|
# >> | attack | defense | technique | note         |
# >> |--------+---------+-----------+--------------|
# >> | []     | []      | []        | ["吊るし桂"] |
# >> | []     | []      | []        | []           |
# >> |--------+---------+-----------+--------------|
# >> 棋戦：共有将棋盤
# >> 先手の備考：吊るし桂
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・v金v玉v金 ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ 馬 ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：桂
# >> 先手番
# >> 手数----指手---------消費時間--
# >>    1 ４三桂打
# >> *▲備考：吊るし桂
# >>    2 詰み
# >> まで1手で先手の勝ち
