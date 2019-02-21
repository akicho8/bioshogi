module Warabi
  class KifuFormatInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "kif",  },
      { key: "ki2",  },
      { key: "csa",  },
      { key: "sfen", },
    ]

    def name
      @name ||= key.to_s.upcase
    end
  end
end
