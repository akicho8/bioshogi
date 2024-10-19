require "./setup"
Explain::TacticInfo[:attack].model # => Bioshogi::Explain::AttackInfo
Explain::TacticInfo[:attack].name  # => "戦法"

tp Explain::TacticInfo.piece_hash_table

# list = Explain::TacticInfo.all_elements.collect { |e|
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

# >> |-------------------------+------------------------------------------------------------|
# >> |    [:pawn, false, true] | [<金底の歩>, <こびん攻め>, <垂れ歩>]                       |
# >> |    [:rook, true, false] | [<一間竜>]                                                 |
# >> |   [:pawn, false, false] | [<こびん攻め>]                                             |
# >> | [:silver, false, false] | [<位の確保>]                                               |
# >> | [:knight, false, false] | [<パンツを脱ぐ>]                                           |
# >> |  [:silver, false, true] | [<腹銀>, <尻銀>, <割り打ちの銀>, <たすきの銀>, <桂頭の銀>] |
# >> |  [:bishop, false, true] | [<たすきの角>]                                             |
# >> |  [:knight, false, true] | [<歩頭の桂>, <ふんどしの桂>, <継ぎ桂>]                     |
# >> |   [:lance, false, true] | [<田楽刺し>]                                               |
# >> | [:bishop, false, false] | [<角不成>]                                                 |
# >> |   [:rook, false, false] | [<飛車不成>]                                               |
# >> |   [:king, false, false] | [<入玉>]                                                   |
# >> |-------------------------+------------------------------------------------------------|
# >> {}
