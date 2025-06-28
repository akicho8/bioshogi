# frozen-string-literal: true

module Bioshogi
  module Hand
    class Move
      include Shared

      attr_accessor :origin_soldier
      attr_accessor :captured_soldier

      def execute(container)
        if captured_soldier
          container.board.safe_delete_on(soldier.place)
          player = container.player_at(soldier.location)
          player.piece_box.add(captured_soldier.piece.key => 1)
        end
        container.board.pick_up(origin_soldier.place)
        container.board.place_on(soldier)
      end

      def revert(container)
        container.board.pick_up(soldier.place)
        container.board.place_on(origin_soldier)

        if captured_soldier
          player = container.player_at(soldier.location)
          player.piece_box.pick_out(captured_soldier.piece)
          container.board.place_on(captured_soldier)
        end
      end

      # 成ったか？
      def promote_trigger?
        !origin_soldier.promoted && soldier.promoted
      end

      # 成れる状態だった？
      def state_where_it_can_become_promote?
        origin_soldier.tsugini_nareru_on?(soldier.place)
      end

      # 駒を取った場合、自分より弱い駒を取った？
      # 厳密な比較ではなく、玉・大駒・小駒で決める
      # def jibunyori_yowai_komawo_totta?
      #   if captured_soldier
      #     soldier.piece.category_score > captured_soldier.piece.category_score
      #   end
      # end

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
        if state_where_it_can_become_promote?
          if promote_trigger?
            :t_promote_on
          else
            :t_promote_throw
          end
        else
          :t_move
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
end
