# frozen-string-literal: true

module Warabi
  class YomiageFormatter < OfficialFormatter
    def location_name
      location.kifuyomi(handicap) + "、"
    end

    def piece_name
      piece.kifuyomi(false)
    end

    def place_name
      place_to.kifuyomi
    end

    def soldier_name
      soldier.kifuyomi
    end

    def kw(s)
      YomikataInfo.fetch(s).yomikata
    end
  end
end
