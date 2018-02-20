module Warabi
  concern :MediatorTest do
    class_methods do
      def test1(params = {})
        mediator = new

        if params[:init]
          mediator.board.placement_from_human(params[:init])
        end

        if params[:pieces_set]
          mediator.pieces_set(params[:pieces_set])
        end

        mediator.execute(params[:execute])
        mediator
      end

      def player_test(params = {})
        params = {
          player: :black,
          initial_deal: true,
        }.merge(params)

        mediator = new
        player = mediator.player_at(params[:player])

        if params[:initial_deal]
          player.pieces_add("歩9角飛香2桂2銀2金2玉")
        end

        if v = params[:pieces_add]
          player.pieces_add(v)
        end

        if v = params[:init]
          player.soldier_create(v)
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
        mediator = new
        player = mediator.player_at(:black)
        player.pieces_add("歩9角飛香2桂2銀2金2玉")
        player.soldier_create(params[:init] || [], from_stand: false)
        Array.wrap(params[:execute]).each { |v| player.execute(v) }
        mediator.hand_logs.last.to_kif_ki2
      end
    end
  end
end
