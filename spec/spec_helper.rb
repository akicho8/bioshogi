# -*- coding: utf-8 -*-
require "bundler/setup"
require "tapp"
require "bushido"

RSpec.configure do |config|
  config.before(:each) do
  end

  module TestHelper
    def player_test(params = {})
      params = {
        :player => :black,
        :initial_deal => true,
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

      # あとでくばる(というかセットする)
      if v = params[:reset_pieces]
        player.piece_discard
        player.deal(v)
      end

      player
    end

    def player_test2(*args)
      player_test(*args).soldier_names.sort
    end
  end

  config.include TestHelper
end
