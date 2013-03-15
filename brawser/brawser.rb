# -*- coding: utf-8 -*-
# WEBインタフェース

require "bundler/setup"
require "bushido"
require "sinatra/base"
require "sinatra/multi_route"
require "sinatra/reloader"
require "uri"
require "redis"
require "sass"
require "haml"
require "compass"
require "bushido/contrib/effective_patterns"

class FrameDecorator < SimpleDelegator
  def to_html_board(type = :default)
    rows = Bushido::Position::Vpos.ridge_length.times.collect do |y|
      tds = Bushido::Position::Hpos.ridge_length.times.collect do |x|
        tag_class = []
        cell = ""
        if soldier = board.surface[[x, y]]
          tag_class << soldier.player.location.key
          if point_logs.last == Bushido::Point[[x, y]]
            tag_class << "last_point"
          end
          cell = soldier.piece_current_name
        end
        "<td class=\"#{tag_class.join(' ')}\">#{cell}</td>"
      end
      "<tr>#{tds.join("\n")}</tr>"
    end
    "<table class=\"board #{type}\">\n#{rows.join("\n")}\n</table>"
  end
end

redis_args = {}
if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  redis_args = {:host => uri.host, :port => uri.port, :password => uri.password}
end
REDIS = Redis.new(redis_args)
REDIS.flushdb

class Brawser < Sinatra::Base
  register Sinatra::MultiRoute

  configure :development do
    register Sinatra::Reloader
  end

  set :sessions, true

  get "/stylesheet.css" do
    # FIXME: cache
    sass :stylesheet, Compass.sass_engine_options
  end

  route :get, :post, "/" do
    @session_id = env["rack.session"]["session_id"]

    if !params[:reset].nil? || REDIS.get(@session_id).nil?
      mediator = Bushido::Mediator.start
      mediator.piece_plot
      REDIS.set(@session_id, Marshal.dump(mediator))
    end

    @mediator = Marshal.load(REDIS.get(@session_id))

    if params[:location].blank? || @mediator.current_player.location.key.to_s == params[:location]
      if params[:way].present?
        @mediator.execute(params[:way])
      end
      if params[:auto].present?
        if way = @mediator.current_player.generate_way.presence
          # if way = @mediator.current_player.brain.best_way.presence
          @mediator.execute(way)
        end
      end
    end

    REDIS.set(@session_id, Marshal.dump(@mediator))

    haml :show
  end

  get "/effective_patterns" do
    if params[:id]
      @pattern = Bushido::EffectivePatterns[params[:id].to_i]
    end
    if @pattern
      mediator = Bushido::SimulatorFrame.new(@pattern)
      @frames = mediator.to_all_frames
    end
    haml :effective_patterns
  end

  get "/board_points" do
    session[:test_count] ||= 0
    session[:start_time] ||= Time.now
    if params[:count].blank?
      session[:test_count] = 0
      session[:start_time] = Time.now
    end
    count = params[:count].to_i
    session[:test_count] += count
    begin
      @mediator = Bushido::Mediator.start
      count.times do
        arg = {:point => Bushido::Point.to_a.sample, :piece => Bushido::Piece.to_a.sample, :promoted => [true, false].sample}
        @mediator.players.sample.initial_soldiers(arg, :from_piece => false)
      end
    rescue Bushido::NotPutInPlaceNotBeMoved, Bushido::NotPromotable, Bushido::PieceAlredyExist => error
      retry
    end
    haml :board_points
  end

  error do
    @error = env["sinatra.error"]
    haml :show
  end
end
