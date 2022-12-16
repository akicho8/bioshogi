module Bioshogi
  module ScreenImage
    class PieceFontWeightInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :is_piece_font_weight_auto,   name: "おまかせ", to_params: {                                                         }, },
        { key: :is_piece_font_weight_normal, name: "細字",     to_params: { soldier_font_bold: false, stand_piece_font_bold: false, }, },
        { key: :is_piece_font_weight_bold,   name: "太字",     to_params: { soldier_font_bold: true,  stand_piece_font_bold: true,  }, },
      ]
    end
  end
end
