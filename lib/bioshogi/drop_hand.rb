# frozen-string-literal: true

module Bioshogi
  class DropHand
    include HandShared

    def initialize(*)
      super
      if soldier.promoted
        raise MustNotHappen, "成駒を打った"
      end
    end

    def execute(mediator)
      player = mediator.player_at(soldier.location_info)
      player.piece_box.pick_out(soldier.piece)
      mediator.board.place_on(soldier)
    end

    def revert(mediator)
      mediator.board.safe_delete_on(soldier.place)
      player = mediator.player_at(soldier.location_info)
      player.piece_box.add(soldier.piece.key => 1)
    end

    def soldier_for_counts
      soldier
    end

    def to_kif(options = {})
      options = {
        with_location: true,
      }.merge(options)

      if options[:with_location]
        s = soldier.name(options)
      else
        s = soldier.name_without_location(options)
      end
      s + "打"
    end

    def to_csa(options = {})
      [
        soldier.location_info.csa_sign,
        "00",
        soldier.place.hankaku_number,
        soldier.to_csa,
      ].join
    end

    def to_sfen(options = {})
      [
        soldier.piece.to_sfen,
        "*",
        soldier.place.to_sfen,
      ].join
    end

    def type
      "t_drop"
    end

    def to_akf(options = {})
      {
        :_location => soldier.location_info.key,
        :type      => type,
        :to        => soldier.place.to_human_h,
        :piece     => soldier.piece.key,
        :_sfen     => to_sfen,
        :_kif      => to_kif,
        :_csa      => to_csa,
      }
    end
  end
end
