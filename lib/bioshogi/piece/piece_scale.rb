# frozen-string-literal: true

module Bioshogi
  class Piece
    class PieceScale
      include ApplicationMemoryRecord
      memory_record [
        # http://kijishi.html.xdomain.jp/komanosize.htm
        { key: :king,   scale: 1.00, }, # 王が一番大きい
        { key: :rook,   scale: 0.99, }, # 飛車と角の大きさは同じでよい
        { key: :bishop, scale: 0.99, },
        { key: :gold,   scale: 0.98, }, # 金・銀の大きさは同じ
        { key: :silver, scale: 0.98, },
        { key: :knight, scale: 0.97, }, # 桂馬の香車の差は大きい
        { key: :lance,  scale: 0.95, },
        { key: :pawn,   scale: 0.94, },
      ]
    end
  end
end
