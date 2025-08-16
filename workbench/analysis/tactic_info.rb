require "#{__dir__}/setup"
Analysis::TacticInfo[:attack].model # => Bioshogi::Analysis::AttackInfo
Analysis::TacticInfo[:attack].name  # => "戦法"
Analysis::TacticInfo["戦法"].name   # => "戦法"

# list = Analysis::TagIndex.values.collect { |e|
#   s = e.name
#   s = s.tr("０１２３４５６７８９", "0123456789")
#   s = s.gsub(/(\d)(\d)/) do |s|
#     a, b = Regexp.last_match.captures
#     a + b.tr("0123456789", "零一二三四五六七八九")
#   end
#   if e.name != s
#     [e.name, s]
#   end
# }.compact
# p list.to_h
# list.each do |a, b|
#   puts "r -x '#{a}' '#{b}' ~/src/bioshogi ~/src/shogi-extend"
#   puts "n -x '#{a}' '#{b}' ~/src/bioshogi ~/src/shogi-extend"
# end
