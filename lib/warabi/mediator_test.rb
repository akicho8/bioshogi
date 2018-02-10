module Warabi
  concern :MediatorTest do
    class_methods do
      def test1(params = {})
        params = {
        }.merge(params)

        mediator = start

        if params[:init]
          mediator.soldiers_create(params[:init])
        end

        if params[:init2]
          mediator.soldiers_create(params[:init2], from_stand: false)
        end

        if params[:pieces_set]
          mediator.pieces_set(params[:pieces_set])
        end

        if params[:piece_box_clear]
          mediator.piece_box_clear
        end

        mediator.execute(params[:exec])
        mediator
      end

      def test2(params = {})
        start.tap do |o|
          Utils.ki2_parse(params[:exec]).each do |op|
            player = o.player_at(op[:location])
            player.execute(op[:input])
          end
        end
      end

      # mediator = Mediator.test3(init: "▲１二歩", pieces_set: "▲歩")
      # mediator = Mediator.test3(init: "▲３三歩 △１一歩")
      # mediator = Mediator.test3(init: "▲１三飛 △１一香 △１二歩")
      # mediator = Mediator.test3(init: "▲１六香 ▲１七飛 △１二飛 △１三香 △１四歩")
      def test3(params = {})
        new.tap do |o|
          o.soldiers_create(params[:init], from_stand: false)
          o.pieces_set(params[:pieces_set].to_s)
        end
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
          player.soldiers_create(v)
        end

        if params[:piece_plot]
          player.piece_plot
        end

        Array.wrap(params[:exec]).each { |v| player.execute(v) }

        if v = params[:pieces_set]
          player.pieces_set(v)
        end

        player
      end

      def player_test_soldier_names(*args)
        player_test(*args).soldiers.collect(&:name).sort
      end

      def read_spec(*args)
        player_test(*args).runner.hand_log.to_kif_ki2
      end
    end
  end
end
