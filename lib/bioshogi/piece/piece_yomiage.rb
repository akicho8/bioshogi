# frozen-string-literal: true

module Bioshogi
  class Piece
    class YomiagePieceInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :king,   name: "gyoku",  promoted_name: nil,         },
        { key: :rook,   name: "hisha",  promoted_name: "ryu",       }, # 「飛車」だと発音がおかしいため
        { key: :bishop, name: "kaku",   promoted_name: "うま",      }, # 「角」は「かど」、「馬」は「ば」と読まれてしまうため
        { key: :gold,   name: "kin",    promoted_name: nil,         },
        { key: :silver, name: "gin",    promoted_name: "なりgin",   },
        { key: :knight, name: "keima",  promoted_name: "なりkei",   },
        { key: :lance,  name: "kyo",    promoted_name: "なりkyo",   },
        { key: :pawn,   name: "hu",     promoted_name: "「と」",    },
      ]

      def piece
        Piece[key]
      end

      def yomiage(promoted)
        if promoted
          promoted_name
        else
          name
        end
      end
    end
  end
end
