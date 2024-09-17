module Bioshogi
  class KifuFormatInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :kif,  },
      { key: :ki2,  },
      { key: :csa,  },
      { key: :sfen, },
    ]

    def name
      super.upcase
    end
  end
end
