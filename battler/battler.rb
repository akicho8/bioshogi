# -*- coding: utf-8 -*-
#
# WEBインタフェース
#

require "bundler/setup"
require "bushido"
require "sass"
require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/multi_route"

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

set :sessions, true

require 'compass'

# get_compass("css")

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir     = 'views'
  end
end

get "/stylesheet.css" do
  # content_type 'text/css'
  sass :stylesheet, Compass.sass_engine_options
end

route :get, :post, "/" do
  if params[:reset] == "1" || session[:frame].nil?
    frame = Bushido::LiveFrame.basic_instance
    frame.piece_plot
    session[:frame] = Marshal.dump(frame)
  end

  @frame = Marshal.load(session[:frame])

  # if @frame.current_player.location.black?
  #   if params[:way]
  #     @frame.execute(params[:way])
  #   end
  # end
  # if @frame.current_player.location.white?
  #   if params[:location] == "white"
  #     way = @frame.current_player.generate_way
  #     @frame.execute(way)
  #   end
  # end

  begin
    if way = @frame.current_player.generate_way.presence
      @frame.execute(way)
    end
  rescue Bushido::BushidoError => error
    @error = error
  end

  # # while true
  # way = @frame.current_player.generate_way
  # @frame.execute(way)
  # last_piece = @frame.prev_player.last_piece
  # if last_piece && last_piece.sym_name == :king
  #   break
  # end
  # end

  unless @error
    session[:frame] = Marshal.dump(@frame)
  end

  @frame_decorator = FrameDecorator.new(@frame)
  erb :show
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
<form action="/" method="post">
<input type="hidden" name="reset" value="1" />
<input type="submit" value="リセット" />
</form>

<%= @frame_decorator.counter_human_name %>手目
<%= @frame_decorator.current_player.location.mark_with_name %>番

<form action="/" method="post">
▽CPU:
<input type="hidden" name="location" value="white" />
<input type="submit" value="打" />
</form>

持駒: <%= @frame_decorator.players.last.to_s_pieces %>
<%= @frame_decorator.to_html_board %>
持駒: <%= @frame_decorator.players.first.to_s_pieces %>

<form action="/" method="post">
<input type="hidden" name="location" value="black" />
▲あなた: <input name="way" value="" />
  <input type="submit" value="打" />
</form>

棋譜: <%= @frame.kif2_logs.join(" ") %>

<%= @error %>

)
end
