# frozen-string-literal: true

module Bioshogi
  class MoveHand
    include HandShared

    attr_accessor :origin_soldier
    attr_accessor :captured_soldier

    def execute(xcontainer)
      if captured_soldier
        xcontainer.board.safe_delete_on(soldier.place)
        player = xcontainer.player_at(soldier.location)
        player.piece_box.add(captured_soldier.piece.key => 1)
      end
      xcontainer.board.pick_up(origin_soldier.place)
      xcontainer.board.place_on(soldier)
    end

    def revert(xcontainer)
      xcontainer.board.pick_up(soldier.place)
      xcontainer.board.place_on(origin_soldier)

      if captured_soldier
        player = xcontainer.player_at(soldier.location)
        player.piece_box.pick_out(captured_soldier.piece)
        xcontainer.board.place_on(captured_soldier)
      end
    end

    # 成ったか？
    def promote_trigger?
      !origin_soldier.promoted && soldier.promoted
    end

    # 成れる状態だった？
    def promotable?
      origin_soldier.next_promotable?(soldier.place)
    end

    # 人間には読みやすいがパースは大変
    # ・不成がわからない
    def to_kif(options = {})
      options = {
        with_location: true,
      }.merge(options)

      [
        options[:with_location] ? soldier.location.name : nil, # "▲"
        soldier.place.name,                                    # "29"
        origin_soldier.any_name(options),                      # "飛"
        promote_trigger? ? "成" : "",                          # "成"
        "(", origin_soldier.place.hankaku_number, ")",         # "(28)"
      ].join
    end

    # CSAは成ったあとの状態を書くだけ
    # ・元々龍だったかわからない
    # ・いま龍になったかわからない
    # ・不成がわからない
    def to_csa(options = {})
      [
        soldier.location.csa_sign,           # "+"
        origin_soldier.place.hankaku_number, # "28"
        soldier.place.hankaku_number,        # "29"
        soldier.to_csa,                      # "RY"
      ].join
    end

    # SFENは移動元と先と今成ったかだけ
    # ・何の駒を動かしたかわからない
    # ・不成がわからない
    def to_sfen(options = {})
      [
        origin_soldier.place.to_sfen, # 2h
        soldier.place.to_sfen,        # 2a
        promote_trigger? ? "+" : nil, # +
      ].join
    end

    def soldier_for_counts
      origin_soldier
    end

    def type
      if promotable?
        if promote_trigger?
          "t_promote_on"
        else
          "t_promote_throw"
        end
      else
        "t_move"
      end
    end

    def to_akf(options = {})
      {
        :_location => origin_soldier.location.key,
        :type      => type,
        :piece     => origin_soldier.piece.key,
        :promoted  => origin_soldier.promoted,
        :from      => origin_soldier.place.to_human_h,
        :to        => soldier.place.to_human_h,
        :captured  => captured_soldier ? captured_soldier.to_akf : nil,
        :_sfen     => to_sfen,
        :_kif      => to_kif,
        :_csa      => to_csa,
      }
    end
  end
end
