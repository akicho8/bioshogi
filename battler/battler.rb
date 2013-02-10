# -*- coding: utf-8 -*-
#
# WEBインタフェース
#

require "bundler/setup"
require "bushido"
require "sass"
require "sinatra/base"
require "sinatra/multi_route"
require "sinatra/reloader"
require 'compass'
require "redis"
require "uri"

class FrameDecorator < SimpleDelegator
  def to_html_board
    rows = Bushido::Position::Vpos.ridge_length.times.collect do |y|
      tds = Bushido::Position::Hpos.ridge_length.times.collect do |x|
        tag_class = []
        cell = "&nbsp;"
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
# ENV["REDISTOGO_URL"] = "redis://redistogo:b887a8f3e4b1293967b4a44a44e60854@dory.redistogo.com:9920/"
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
    session_id = env["rack.session"]["session_id"]

    if !params[:reset].nil? || REDIS.get(session_id).nil?
      frame = Bushido::LiveFrame.basic_instance
      frame.piece_plot
      # session[:frame] = Marshal.dump(frame)
      REDIS.set(session_id, Marshal.dump(frame))
    end

    @frame = Marshal.load(REDIS.get(session_id))

    # if @frame.current_player.location.key.to_s == params[:location]
    if params[:way].present?
      @frame.execute(params[:way])
    end
    if params[:auto].present?
      if way = @frame.current_player.generate_way.presence
        @frame.execute(way)
      end
    end
    # end

    REDIS.set(session_id, Marshal.dump(@frame))
    @frame_decorator = FrameDecorator.new(@frame)
    erb :show
  end

  error do
    @error = env['sinatra.error']
    @frame_decorator = FrameDecorator.new(@frame)
    erb :show
    # else
    #   session_id = env["rack.session"]["session_id"]
    #   REDIS.set(session_id, nil)
    #
    #   response.status = 500
    #   content_type 'text/html'
    #   "#{@error.class} #{@error.message}"
    # end
  end

  template :layout do
    %(<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <link href="/stylesheet.css" media="screen" rel="stylesheet" type="text/css" />
  </head>
  <body>
<%= yield %>
</body>
</html>)
  end

  template :show do
    %(
<% if @error %>
  <%= @error.message %>
  (<%= @error.class.name %>)
  <br/>
<% end %>

<form action="/" method="post" style="display:inline-block">
<input type="hidden" name="reset" value="true" />
<input type="submit" value="リセット" />
</form>

  <form action="/" method="post" style="display:inline-block">
    <input type="hidden" name="auto" value="true" />
    <input type="submit" value="鬼神迷走" />
  </form>

<br/>

<%= @frame_decorator.counter_human_name %>手目
<%= @frame_decorator.current_player.location.mark_with_name %>番

<form action="/" method="post">
▽CPU:
    <input type="hidden" name="location" value="white" />
    <input type="hidden" name="auto" value="true" />
    <input type="submit" value="打" />
</form>

持駒: <%= @frame_decorator.players.last.to_s_pieces %>
<%= @frame_decorator.to_html_board %>
持駒: <%= @frame_decorator.players.first.to_s_pieces %>

<br/>

▲あなた:

  <form action="/" method="post" style="display:inline-block">
    <input type="hidden" name="location" value="black" />
    <input name="way" value="" />
    <input type="submit" value="打" />
  </form>

<br/>

棋譜: <%= @frame.kif2_logs.join(" ") %>

<br/>
<%= env["rack.session"]["session_id"].to_s.slice(/^.{7}/) %><br/>
<%= params.inspect %><br/>
<%= ENV['RACK_ENV'] %><br/>

)
  end
end

