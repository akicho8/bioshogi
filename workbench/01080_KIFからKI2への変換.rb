require "./setup"

info = Bioshogi::Parser.parse(Pathname("katomomo.kif"))

out = ""
out << info.pi.header.to_h.collect { |key, value| "#{key}：#{value}\n" }.join
out << "\n"
# puts info

container = Container::Basic.new
container.placement_from_preset(info.pi.header["手合割"])
info.pi.move_infos.each do |info|
  container.execute(info[:input])
end
out << container.to_ki2_a.group_by.with_index { |_, i|i / 10 }.values.collect { |v| v.join(" ") + "\n" }.join
out << container.judgment_message
puts out

# >> 開始日時：2017/11/11 10:00:00
# >> 終了日時：2017/11/11 17:22:00
# >> 棋戦：女流王座戦
# >> 場所：大阪・芝苑
# >> 手合割：平手
# >> 先手：加藤桃子 女王
# >> 後手：里見香奈 女流王座
# >> 戦法：ゴキゲン中飛車
# >>
# >> ▲２六歩 △３四歩 ▲２五歩 △３三角 ▲７六歩 △４二銀 ▲４八銀 △５四歩 ▲６八玉 △５五歩
# >> ▲３六歩 △５二飛 ▲３七銀 △５三銀 ▲４六銀 △４四銀 ▲５八金右 △６二玉 ▲７八玉 △７二玉
# >> ▲６六歩 △８二玉 ▲６七金 △７二銀 ▲７七角 △９四歩 ▲８八玉 △９五歩 ▲９八香 △８四歩
# >> ▲９九玉 △８三銀 ▲８八銀 △７二金 ▲６五歩 △７四歩 ▲６六金 △７三桂 ▲８六角 △５一飛
# >> ▲７八飛 △８五歩 ▲５九角 △４二角 ▲７九金 △３三桂 ▲７五歩 △同歩 ▲同金 △同角
# >> ▲同飛 △７四歩 ▲７六飛 △７五金 ▲７八飛 △５六歩 ▲同歩 △６五金 ▲５五歩 △５六歩
# >> ▲２六角 △１四歩 ▲６二歩 △５二金 ▲６一歩成 △同飛 ▲５四歩 △６六金 ▲６八飛 △７六金
# >> ▲７七歩 △７五金 ▲５八飛 △６六金 ▲６八飛 △６五金 ▲３二角 △８六歩 ▲同歩 △３五歩
# >> ▲２三角成 △６四歩 ▲３五歩 △２一飛 ▲３四馬 △９二香 ▲４八角 △９一飛 ▲２四歩 △７五金
# >> ▲５六馬 △８四歩 ▲７五角 △同歩 ▲６四飛 △６三金左 ▲６八飛 △６五角 ▲同飛 △同桂
# >> ▲同馬 △５九飛 ▲６六桂 △７三金上 ▲５二角 △６四金直 ▲同馬 △同金 ▲６五歩 △４八角
# >> ▲６四歩 △６六角成 ▲７三金
# >> まで113手で先手の勝ち
