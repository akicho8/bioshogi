# frozen-string-literal: true

module Warabi
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
          hand = InputParser.slice_one(think_result[:hand])
          puts "指し手: #{hand}"
          mediator.execute(hand)

          last_captured_piece = mediator.flip_player.last_captured_piece
          if last_captured_piece && last_captured_piece.key == :king
            break
          end
        end
        p mediator.kif_hand_logs.join(" ")
      end
    end
  end
end
