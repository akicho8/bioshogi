# $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# require 'warabi'

require "bundler/setup"
require "tapp"
require "warabi"
require "warabi/mediator_test_helper"

ENV["WARABI_ENV"] = "test"

log_file = Pathname(__FILE__).dirname.join("../log/test.log").expand_path
FileUtils.makedirs(log_file.dirname)
Warabi.logger = ActiveSupport::Logger.new(log_file)

module Warabi
  Mediator.include(MediatorTestHelper)
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :minitest

  # config.order = :random

  config.before(:each) do
  end

  config.include Module.new {
    def player_test(params = {})
      params = {
        player: :black,
        initial_deal: true,
      }.merge(params)

      mediator = Warabi::Mediator.new
      player = mediator.player_at(params[:player])

      if params[:initial_deal]
        player.pieces_add("歩9角飛香2桂2銀2金2玉")
      end

      if v = params[:append_pieces]
        player.pieces_add(v)
      end

      player.soldiers_create(params[:init])

      if params[:run_piece_plot]
        player.piece_plot
      end

      Array.wrap(params[:exec]).each { |v| player.execute(v) }

      if v = params[:pieces_set]
        player.pieces_set(v)
      end

      player
    end

    def player_test2(*args)
      player_test(*args).soldiers.collect(&:name).sort
    end

    def read_spec(*args)
      player_test(*args).runner.hand_log.to_kif_ki2
    end

    def read_spec2(*args)
      player_test(*args).runner.hand_log.to_kif_ki2_csa
    end
  }
end
