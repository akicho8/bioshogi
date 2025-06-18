# frozen-string-literal: true

module Bioshogi
  class HandLog
    include SimpleModel

    attr_accessor :drop_hand
    attr_accessor :move_hand

    attr_accessor :candidate_soldiers
    attr_accessor :place_same
    attr_accessor :tag_bundle
    attr_accessor :handicap

    attr_accessor :single_clock

    delegate :soldier, to: :hand

    def to_kif(options = {})
      options = {
        :with_location => false,
        :char_type     => :formal_sheet,
      }.merge(options)

      hand.to_kif(options)
    end

    def to_ki2(...)
      official_formatter(...).to_s
    end

    def yomiage(...)
      yomiage_formatter(...).to_s
    end

    def to_csa(...)
      hand.to_csa(...)
    end

    def to_sfen(...)
      hand.to_sfen(...)
    end

    def to_akf(...)
      hand.to_akf(...)
    end

    def to_kif_ki2
      [to_kif, to_ki2]
    end

    def to_kif_ki2_csa
      [to_kif, to_ki2, to_csa]
    end

    def kif_comment(options = {})
      tag_bundle.kif_comment(soldier.location)
    end

    def hand
      move_hand || drop_hand
    end

    def official_formatter(...)
      OfficialFormatter.new(self, ...)
    end

    def yomiage_formatter(...)
      Yomiage::Formatter.new(self, ...)
    end
  end
end
