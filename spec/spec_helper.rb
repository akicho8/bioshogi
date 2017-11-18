# $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# require 'bushido'

require "bundler/setup"
require "tapp"
require "bushido"

log_file = Pathname(__FILE__).dirname.join("../log/test.log").expand_path
FileUtils.makedirs(log_file.dirname)
Bushido.logger = ActiveSupport::Logger.new(log_file)

module Bushido
  Mediator.send(:include, MediatorTestHelper)
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.before(:each) do
  end

  config.include Module.new {
    def player_test(params = {})
      params = {
        player: :black,
        initial_deal: true,
      }.merge(params)

      mediator = Bushido::Mediator.new
      player = mediator.player_at(params[:player])

      if params[:initial_deal]
        player.pieces_add
      end

      player.pieces_add(params[:append_pieces])

      player.initial_soldiers(params[:init])

      if params[:run_piece_plot]
        player.piece_plot
      end

      Array.wrap(params[:exec]).each{|v|player.execute(v)}

      if v = params[:pinit]
        player.pieces_set(v)
      end

      player
    end

    def player_test2(*args)
      player_test(*args).soldier_names.sort
    end

    def read_spec(*args)
      player_test(*args).runner.hand_log.to_kif_ki2
    end

    def board_parse_test(source)
      Bushido::Parser.board_parse(source).inject({}) do |a, (key, value)|
        a.merge(key => value.collect(&:to_s))
      end
    end

    def board_one_cell(str)
      "+---+\n|#{str}|\n+---+"
    end
  }
end
