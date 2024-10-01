require "./setup"
Explain::TacticInfo[:attack].model # => Bioshogi::Explain::AttackInfo
Explain::TacticInfo[:attack].name  # => "戦法"

tp Explain::TacticInfo.piece_hash_table
# >> |-------------------------+----------------------------------------------------|
# >> |    [:pawn, false, true] | [<金底の歩>, <垂れ歩>]                             |
# >> | [:knight, false, false] | [<パンツを脱ぐ>]                                   |
# >> |  [:silver, false, true] | [<腹銀>, <割り打ちの銀>, <たすきの銀>, <桂頭の銀>] |
# >> |  [:bishop, false, true] | [<たすきの角>]                                     |
# >> |   [:lance, false, true] | [<田楽刺し>, <ロケット>]                           |
# >> |  [:knight, false, true] | [<ふんどしの桂>, <継ぎ桂>]                         |
# >> |  [:lance, false, false] | [<ロケット>]                                       |
# >> |    [:rook, false, true] | [<ロケット>]                                       |
# >> |   [:rook, false, false] | [<ロケット>, <飛車不成>]                           |
# >> |     [:rook, true, true] | [<ロケット>]                                       |
# >> |    [:rook, true, false] | [<ロケット>]                                       |
# >> | [:bishop, false, false] | [<角不成>]                                         |
# >> |   [:king, false, false] | [<入玉>]                                           |
# >> |-------------------------+----------------------------------------------------|
