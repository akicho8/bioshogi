module Bioshogi
  concern :XcontainerTest do
    class_methods do
      def facade(params = {})
        xcontainer = new

        if params[:init]
          xcontainer.board.placement_from_human(params[:init])
        end

        if params[:pieces_set]
          xcontainer.pieces_set(params[:pieces_set])
        end

        xcontainer.execute(params[:execute])
        xcontainer
      end

      def player_test(params = {})
        params = {
          player: :black,
          initial_deal: true,
        }.merge(params)

        xcontainer = new
        player = xcontainer.player_at(params[:player])

        if params[:initial_deal]
          player.pieces_add("歩9角飛香2桂2銀2金2玉")
        end

        if v = params[:pieces_add]
          player.pieces_add(v)
        end

        if v = params[:init]
          player.soldier_create(v, from_stand: true)
        end

        Array.wrap(params[:execute]).each { |v| player.execute(v) }

        if v = params[:pieces_set]
          player.pieces_set(v)
        end

        player
      end

      def player_test_soldier_names(*args)
        player_test(*args).soldiers.collect(&:name).sort
      end

      def read_spec(params)
        xcontainer = new
        player = xcontainer.player_at(:black)
        player.pieces_add("歩9角飛香2桂2銀2金2玉")
        player.placement_from_human(Array(params[:init]).join.gsub(/_/, ""))
        Array.wrap(params[:execute]).each { |v| player.execute(v) }
        xcontainer.hand_logs.last.to_kif_ki2
      end
    end
  end
end
