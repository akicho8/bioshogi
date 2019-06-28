# frozen-string-literal: true

module Bioshogi
  class HandLog
    include SimpleModel

    attr_accessor :drop_hand
    attr_accessor :move_hand

    attr_accessor :candidate
    attr_accessor :place_same
    attr_accessor :skill_set
    attr_accessor :handicap

    attr_accessor :personal_clock

    def to_kif(**options)
      options = {
        with_location: false,
        char_type: :formal_paper,
      }.merge(options)

      hand.to_kif(options)
    end

    def to_ki2(**options)
      official_formatter(options).to_s
    end

    def yomiage(**options)
      yomiage_formatter(options).to_s
    end

    def to_csa(**options)
      hand.to_csa(options)
    end

    def to_sfen(**options)
      hand.to_sfen(options)
    end

    def to_kif_ki2
      [to_kif, to_ki2]
    end

    def to_kif_ki2_csa
      [to_kif, to_ki2, to_csa]
    end

    def to_skill_set_kif_comment(**options)
      skill_set.kif_comment(soldier.location)
    end

    def soldier
      hand.soldier
    end

    def hand
      move_hand || drop_hand
    end

    def official_formatter(**options)
      OfficialFormatter.new(self, options)
    end

    def yomiage_formatter(**options)
      YomiageFormatter.new(self, options)
    end
  end
end
