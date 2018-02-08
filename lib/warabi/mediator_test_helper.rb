module Warabi
  concern :MediatorTestHelper do
    class_methods do
      def test(params = {})
        params = {
        }.merge(params)

        mediator = start
        if params[:init]
          mediator.battlers_create(params[:init])
        end
        if params[:init2]
          mediator.battlers_create(params[:init2], from_stand: false)
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

      # mediator = Mediator.simple_test(init: "▲１二歩", pieces_set: "▲歩")
      # mediator = Mediator.simple_test(init: "▲３三歩 △１一歩")
      # mediator = Mediator.simple_test(init: "▲１三飛 △１一香 △１二歩")
      # mediator = Mediator.simple_test(init: "▲１六香 ▲１七飛 △１二飛 △１三香 △１四歩")
      def simple_test(params = {})
        params = {
        }.merge(params)

        new.tap do |o|
          o.battlers_create(params[:init], from_stand: false)
          o.pieces_set(params[:pieces_set].to_s)
        end
      end

      def test2(params = {})
        start.tap do |o|
          Utils.ki2_parse(params[:exec]).each do |op|
            player = o.players[Location[op[:location]].index]
            player.execute(op[:input])
          end
        end
      end
    end
  end
end
