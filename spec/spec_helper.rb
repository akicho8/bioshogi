# -*- coding: utf-8 -*-
require "bundler/setup"
require "tapp"
require "bushido"

module Bushido
  Mediator.send(:include, MediatorTestHelper)
end

RSpec.configure do |config|
  config.before(:each) do
  end

  module TestHelper
    def player_test(params = {})
      params = {
        player: :black,
        initial_deal: true,
      }.merge(params)

      mediator = Bushido::Mediator.new
      player = mediator.player_at(params[:player])

      if params[:initial_deal]
        player.deal
      end

      player.deal(params[:append_pieces])

      player.initial_soldiers(params[:init])

      if params[:run_piece_plot]
        player.piece_plot
      end

      Array.wrap(params[:exec]).each{|v|player.execute(v)}

      if v = params[:pinit]
        player.reset_pieces_from_str(v)
      end

      player
    end

    def player_test2(*args)
      player_test(*args).soldier_names.sort
    end

    def read_spec(*args)
      elems = player_test(*args).runner.hand_log.to_pair
      # elems = elems.collect{|e|e.gsub(/[▲△▽]/, "")}
    end

    def board_parse_test(source)
      Bushido::BaseFormat.board_parse(source).inject({}){|hash, (key, value)|hash.merge(key => value.collect(&:to_s))}
    end

    def board_one_cell(str)
      "+---+\n|#{str}|\n+---+"
    end
  end

  config.include TestHelper
end
