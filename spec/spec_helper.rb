# -*- coding: utf-8 -*-
require "bundler/setup"
require "tapp"
require "bushido"

RSpec.configure do |config|
  config.before(:each) do
  end

  module MyHelper
    def player_basic_test(params = {})
      params = {
        :player => :black,
      }.merge(params)
      mediator = Bushido::Mediator.new
      player = mediator.player_at(params[:player])

      # player = Player.new(:location => params[:player], :board => Board.new, :deal => true)
      player.deal

      # 最初にくばるオプション(追加で)
      player.deal(params[:deal])

      player.initial_soldiers(params[:init])
      if params[:piece_plot]
        player.piece_plot
      end

      Array.wrap(params[:exec]).each{|v|player.execute(v)}

      # あとでくばる(というかセットする)
      if params[:pieces]
        player.piece_discard
        player.deal(params[:pieces])
      end

      player
    end

    def player_basic_test2(*args)
      player_basic_test(*args).soldier_names.sort
    end
  end

  config.include MyHelper
end
