# -*- coding: utf-8 -*-

module Bushido
  class Cli
    class Versus < self
      def self.script_name
        "NegaMaxアルゴリズム同士の対決"
      end

      # def self.process_args(args, options)
      #   options = {
      #     :foo_bar => nil,
      #   }.merge(default_options).merge(options)
      #   opts = OptionParser.new
      #   opts.on("-e", "--email=EMAIL", String, "メールアドレス"){|v|options[:email] = v}
      #   common_options(opts, options)
      #   opts.parse!(args)
      #   [args, options]
      # end

      def execute
        mediator = Mediator.start
        mediator.piece_plot
        loop do
          think_result = mediator.current_player.brain.think_by_minmax(depth: 0, random: true)
          hand = Utils.mov_split_one(think_result[:hand])[:input]
          p hand
          mediator.execute(hand)
          puts mediator
          last_piece = mediator.reverse_player.last_piece
          if last_piece && last_piece.sym_name == :king
            break
          end
        end
        p mediator.simple_hand_logs.join(" ")
      end
    end
  end
end
