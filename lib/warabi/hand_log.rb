# frozen-string-literal: true

module Warabi
  class HandLog
    include ActiveModel::Model

    attr_accessor :point_from
    attr_accessor :point_to
    attr_accessor :piece
    attr_accessor :promoted
    attr_accessor :promote_trigger
    attr_accessor :strike_trigger
    attr_accessor :player
    attr_accessor :candidate
    attr_accessor :point_same
    attr_accessor :skill_set
    attr_accessor :current_soldier
    attr_accessor :before_soldier
    attr_accessor :killed_piece

    def initialize(*)
      super

      raise MustNotHappen, "成駒を打った" if strike_trigger && promoted
      raise MustNotHappen, "打つと同時に成った" if strike_trigger && promote_trigger
      raise MustNotHappen, "成駒をさらに成った" if promoted && promote_trigger
    end

    def to_kif_ki2
      [to_s_kif, to_s_ki2]
    end

    def to_kif_ki2_csa
      [to_s_kif, to_s_ki2, to_s_csa]
    end

    def to_s_kif(**options)
      options = {
        with_mark: false,
      }.merge(options)

      s = []
      if options[:with_mark]
        s << @player.location.mark
      end
      s << @point_to.name
      s << @piece.any_name(@promoted)
      if @promote_trigger
        s << "成"
      end
      if @strike_trigger
        s << "打"
      end
      if @point_from
        s << "(#{@point_from.number_format})"
      end
      s.join
    end

    def to_skill_set_kif_comment(**options)
      skill_set.kif_comment(player.location)
    end

    def to_s_ki2(**options)
      official_formatter(options).to_s
    end

    def official_formatter(**options)
      OfficialFormatter.new(self, options)
    end

    def to_s_csa(**options)
      s = []
      s << @player.location.csa_sign
      if @point_from
        s << @point_from.number_format
      else
        s << "00"               # 駒台
      end
      s << @point_to.number_format
      s << @piece.csa_some_name(@promoted || @promote_trigger)
      s.join
    end

    # http://www.geocities.jp/shogidokoro/usi.html
    # ７六歩(77) -> 7g7f
    # ７六歩成   -> 7g7f+
    # ７六歩打   -> P*7g
    def to_sfen
      s = []
      if @strike_trigger
        s << @piece.to_sfen      # P (歩) 先後に関係なく打つ駒は大文字
        s << "*"                 # 打
        s << @point_to.to_sfen   # 7g (76)
      else
        s << @point_from.to_sfen # 7g (77)
        s << @point_to.to_sfen   # 7f (76)
        if @promote_trigger
          s << "+"               # 成
        end
      end
      s.join
    end

    def to_h
      [:point_to, :piece, :promoted, :promote_trigger, :strike_trigger, :point_from, :player, :candidate, :point_same].inject({}) {|a, key| a.merge(key => send(key)) }
    end
  end
end
