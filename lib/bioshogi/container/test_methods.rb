module Bioshogi
  module Container
    concern :TestMethods do
      class_methods do
        def facade(params = {})
          container = new

          if params[:init]
            container.board.placement_from_human(params[:init])
          end

          if params[:pieces_set]
            container.pieces_set(params[:pieces_set])
          end

          container.execute(params[:execute])
          container
        end

        def player_test(params = {})
          params = {
            player: :black,
            initial_deal: true,
          }.merge(params)

          container = new
          player = container.player_at(params[:player])

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

        def player_test_soldier_names(...)
          player_test(...).soldiers.collect(&:name).sort
        end

        def read_spec(params)
          container = new
          player = container.player_at(:black)
          player.pieces_add("歩9角飛香2桂2銀2金2玉")
          player.placement_from_human(Array(params[:init]).join.gsub(/_/, ""))
          Array.wrap(params[:execute]).each { |v| player.execute(v) }
          container.hand_logs.last.to_kif_ki2
        end
      end
    end
  end
end
