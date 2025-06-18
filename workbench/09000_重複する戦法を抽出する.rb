require "#{__dir__}/setup"

files = Pathname.glob("../../2chkifu/**/*.{ki2,KI2}")
files = files.take(3000000)
files = files.collect(&:expand_path)
hash = Hash.new(0)
files.each do |file|
  puts file
  info = Parser.file_parse(file, typical_error_case: :skip)
  info.container.players.each do |player|
    [:attack_infos, :defense_infos].each do |kind|
      names = player.tag_bundle.public_send(kind).normalize.collect(&:name)
      hash[names] += 1
    end
  end
end
rows = hash.collect { |k, v| { length: k.size, freq: v, list: k } }

rows = rows.sort_by { |e| [-e[:freq], -e[:length]] }
Pathname(__dir__).join("重複戦法1.org").write(rows.to_t)

rows = rows.sort_by { |e| [-e[:length], -e[:freq]] }
Pathname(__dir__).join("重複戦法2.org").write(rows.to_t)

tp rows
# >> /Users/ikeda/src/2chkifu/00001/00002.KI2
# >> /Users/ikeda/src/2chkifu/00001/00003.KI2
# >> /Users/ikeda/src/2chkifu/00001/00004.KI2
# >> /Users/ikeda/src/2chkifu/00001/00005.KI2
# >> /Users/ikeda/src/2chkifu/00001/00006.KI2
# >> /Users/ikeda/src/2chkifu/00001/00007.KI2
# >> /Users/ikeda/src/2chkifu/00001/00008.KI2
# >> /Users/ikeda/src/2chkifu/00001/00009.KI2
# >> /Users/ikeda/src/2chkifu/00001/00010.KI2
# >> /Users/ikeda/src/2chkifu/00001/00011.KI2
# >> |--------+------+---------------------------|
# >> | length | freq | list                      |
# >> |--------+------+---------------------------|
# >> |      2 |    1 | ["相掛かり棒銀", "UFO銀"] |
# >> |      2 |    1 | ["鎖鎌銀", "右四間飛車"]  |
# >> |      1 |    2 | ["カブト囲い"]            |
# >> |      1 |    2 | ["角換わり腰掛け銀旧型"]  |
# >> |      1 |    2 | ["横歩取り"]              |
# >> |      1 |    2 | ["中原囲い"]              |
# >> |      1 |    2 | ["カニ囲い"]              |
# >> |      1 |    2 | ["ゴキゲン中飛車"]        |
# >> |      1 |    2 | ["舟囲い"]                |
# >> |      1 |    1 | ["力戦"]                  |
# >> |      1 |    1 | ["対振り持久戦"]          |
# >> |      1 |    1 | ["△3三角型空中戦法"]     |
# >> |      1 |    1 | ["四間飛車"]              |
# >> |      1 |    1 | ["中住まい"]              |
# >> |      1 |    1 | ["雀刺し"]                |
# >> |      1 |    1 | ["鎖鎌銀"]                |
# >> |      1 |    1 | ["相掛かり"]              |
# >> |      1 |    1 | ["片美濃囲い"]            |
# >> |      1 |    1 | ["矢倉▲3七銀戦法"]       |
# >> |      1 |    1 | ["金矢倉"]                |
# >> |      1 |    1 | ["総矢倉"]                |
# >> |      1 |    1 | ["菊水矢倉"]              |
# >> |      1 |    1 | ["中座飛車"]              |
# >> |      0 |   10 | []                        |
# >> |--------+------+---------------------------|
