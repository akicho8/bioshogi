s = File.read("standard_kif_spec.rb")
list = [
  "123456789",
  "１２３４５６７８９",
  "一二三四五六七八九",
]
n = list.join
s = s.gsub(/[#{n}]{2}/) do |s|
  list.each do |e|
    s = s.tr(e, e.reverse)
  end
  s
end

s = s.gsub(/\|.*\|/) do |s|
  s = s.chars.reverse.join
  s = s.gsub(/ \|/, "|")
  s = s.gsub(/^\|/, "| ")
  s = s.gsub(/ /, "v")
  s = s.gsub(/v・/, " ・")
  s = s.gsub(/v○/, " ○")
end
s = s.gsub(/^\+.*?EOT/m) {|s| s.lines.reverse.drop(1).join + "EOT\n" }

s = s.gsub(/\+(\d\d)/, '-\1')
s = s.gsub(/mediator\.execute/, "mediator.next_player.execute")
s = "# #{__FILE__} から生成するファイルなので変更禁止\n" + s

puts s

File.write("standard_kif_white_side_spec.rb", s)
