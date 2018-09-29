module Warabi
  class PieceYomikata
    include ApplicationMemoryRecord
    memory_record [
      { key: :king,   name: "ぎょく", promoted_name: nil,          },
      { key: :rook,   name: "ひしゃ", promoted_name: "龍",         }, # 「飛車」だと発音がおかしいため
      { key: :bishop, name: "かく",   promoted_name: "うま",       }, # 「角」は「かど」、「馬」は「ば」と読まれてしまうため
      { key: :gold,   name: "金",     promoted_name: nil,          },
      { key: :silver, name: "ぎん",   promoted_name: "成り銀",     },
      { key: :knight, name: "けいま", promoted_name: "なりけい",   },
      { key: :lance,  name: "きょう", promoted_name: "なりきょう", },
      { key: :pawn,   name: "ふ",     promoted_name: "と",         },
    ]

    def piece
      Piece[key]
    end

    def kifuyomi(promoted)
      if promoted
        promoted_name
      else
        name
      end
    end
  end
end
