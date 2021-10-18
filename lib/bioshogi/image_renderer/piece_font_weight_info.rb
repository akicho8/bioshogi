module Bioshogi
  class ImageRenderer
    class PieceFontWeightInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :is_piece_font_weight_auto, name: "おまかせ", to_params: {                                                         }, },
        { key: :is_piece_font_weight_off,  name: "細字",     to_params: { soldier_font_bold: false, stand_piece_font_bold: false, }, },
        { key: :is_piece_font_weight_on,   name: "太字",     to_params: { soldier_font_bold: true, stand_piece_font_bold: true,   }, },
      ]
    end
  end
end
