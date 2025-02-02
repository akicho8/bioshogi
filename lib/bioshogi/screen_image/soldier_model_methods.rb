module Bioshogi
  module ScreenImage
    concern :SoldierModelMethods do
      # 対応する画像のファイル名を返す
      def image_basename
        [
          location.to_sfen,     # B (Black)
          piece.sfen_char,      # P (Pawn)
          promoted ? "1" : "0", # 0 (不成)
        ].join.upcase
      end
    end
  end
end
