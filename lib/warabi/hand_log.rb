# frozen-string-literal: true

module Warabi
  class HandLog
    include ActiveModel::Model

    attr_accessor :current_direct
    attr_accessor :current_moved

    attr_accessor :candidate
    attr_accessor :point_same
    attr_accessor :skill_set
    attr_accessor :killed_piece

    def to_kif(**options)
      options = {
        with_mark: false,
      }.merge(options)

      current_hand.to_kif(options)
    end

    def to_ki2(**options)
      official_formatter(options).to_s
    end

    def to_csa(**options)
      current_hand.to_csa(options)
    end

    def to_sfen(**options)
      current_hand.to_sfen(options)
    end

    def to_kif_ki2
      [to_kif, to_ki2]
    end

    def to_kif_ki2_csa
      [to_kif, to_ki2, to_csa]
    end

    def to_skill_set_kif_comment(**options)
      skill_set.kif_comment(current_soldier.location)
    end

    def current_soldier
      current_hand.soldier
    end

    def current_hand
      current_moved || current_direct
    end

    def official_formatter(**options)
      OfficialFormatter.new(self, options)
    end

    def attributes
      [
        :current_soldier,
        :candidate,
        :point_same,
      ].inject({}) {|a,
        key| a.merge(key => send(key)) }
    end
  end
end
