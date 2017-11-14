module Bushido
  module Cli
    class VersusCommand < Base
      self.command_name = "CPU同士の対局"

      def execute
        mediator = Mediator.start
        mediator.piece_plot
        loop do
          puts "-" * 80
          puts mediator

          think_result = mediator.current_player.brain.think_by_minmax(depth: 0, random: true)
          hand = Utils.mov_split_one(think_result[:hand])[:input]
          puts "指し手: #{hand}"
          mediator.execute(hand)

          last_piece = mediator.reverse_player.last_piece
          if last_piece && last_piece.key == :king
            break
          end
        end
        p mediator.kif_hand_logs.join(" ")
      end
    end
  end
end
