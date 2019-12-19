# frozen-string-literal: true

module Bioshogi
  class Piece
    class PieceCsa
      include ApplicationMemoryRecord
      memory_record [
        { key: :king,   basic_name: "OU", promoted_name: nil,  },
        { key: :rook,   basic_name: "HI", promoted_name: "RY", },
        { key: :bishop, basic_name: "KA", promoted_name: "UM", },
        { key: :gold,   basic_name: "KI", promoted_name: nil,  },
        { key: :silver, basic_name: "GI", promoted_name: "NG", },
        { key: :knight, basic_name: "KE", promoted_name: "NK", },
        { key: :lance,  basic_name: "KY", promoted_name: "NY", },
        { key: :pawn,   basic_name: "FU", promoted_name: "TO", },
      ]

      def piece
        Piece[key]
      end

      def any_name(promoted)
        if promoted
          promoted_name
        else
          basic_name
        end
      end
    end
  end
end
