module Bioshogi
  class ImageRenderer
    class XboldInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :is_xbold_auto, name: "おまかせ", to_params: {                                                         }, },
        { key: :is_xbold_off,  name: "細字",     to_params: { soldier_font_bold: false, stand_piece_font_bold: false, }, },
        { key: :is_xbold_on,   name: "太字",     to_params: { soldier_font_bold: true, stand_piece_font_bold: true,   }, },
      ]
    end
  end
end
