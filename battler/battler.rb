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

class FrameDecorator < SimpleDelegator
  def to_html_board
    rows = Bushido::Position::Vpos.ridge_length.times.collect do |y|
      tds = Bushido::Position::Hpos.ridge_length.times.collect do |x|
        tag_class = []
        cell = ""
        if soldier = board.surface[[x, y]]
          tag_class << soldier.player.location.key
          if last_point == Bushido::Point[[x, y]]
            tag_class << "last_point"
          end
          cell = soldier.piece_current_name
        end
        "<td class=\"#{tag_class.join(' ')}\">#{cell}</td>"
      end
      "<tr>#{tds.join("\n")}</tr>"
    end
    "<table class=\"board\">\n#{rows.join("\n")}\n</table>"
  end
end

redis_args = {}
if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  redis_args = {:host => uri.host, :port => uri.port, :password => uri.password}
end
REDIS = Redis.new(redis_args)
REDIS.flushdb

class Battler < Sinatra::Base
  register Sinatra::MultiRoute

  configure :development do
    register Sinatra::Reloader
  end

  set :sessions, true

  get "/stylesheet.css" do
    sass :stylesheet, Compass.sass_engine_options
  end

  route :get, :post, "/" do
    @session_id = env["rack.session"]["session_id"]

    if !params[:reset].nil? || REDIS.get(@session_id).nil?
      frame = Bushido::LiveFrame.basic_instance
      frame.piece_plot
      REDIS.set(@session_id, Marshal.dump(frame))
    end

    @frame = Marshal.load(REDIS.get(@session_id))

    if params[:location].blank? || @frame.current_player.location.key.to_s == params[:location]
      if params[:way].present?
        @frame.execute(params[:way])
      end
      if params[:auto].present?
        if way = @frame.current_player.generate_way.presence
          @frame.execute(way)
        end
      end
    end

    REDIS.set(@session_id, Marshal.dump(@frame))

    haml :show
  end

  error do
    @error = env["sinatra.error"]
    haml :show
  end
end
