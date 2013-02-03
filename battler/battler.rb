# -*- coding: utf-8 -*-
# 対戦

begin
  require_relative "../lib/bushido"
rescue LoadError
  require File.expand_path(File.join(File.dirname(__FILE__), "../lib/bushido"))
end

include Bushido

class FrameDecorator < SimpleDelegator
  def to_html_board
    rows = Position::Vpos.ridge_length.times.collect{|y|
      tds = Position::Hpos.ridge_length.times.collect{|x|
        tag_class = ""
        cell = " "
        if soldier = board.surface[[x, y]]
          tag_class = soldier.player.location.key
          cell = soldier.piece_current_name
        end
        "<td class=\"#{tag_class}\">#{cell}</td>"
      }
      "<tr>#{tds.join("\n")}</tr>"
    }
    "<table class=\"board\">\n#{rows.join("\n")}\n</table>"
  end
end

require "sinatra"
require "sass"
set :sessions, true

get "/stylesheet.css" do
  sass :stylesheet
end

get "/" do
  session[:count] ||= 0
  session[:count] += 1
  session[:count].to_s

  @frame = LiveFrame.basic_instance
  @frame.piece_plot

  # while true
  way = @frame.current_player.generate_way
  @frame.execute(way)
  last_piece = @frame.prev_player.last_piece
  # if last_piece && last_piece.sym_name == :king
  #   break
  # end

  # end

  @frame_decorator = FrameDecorator.new(@frame)

  # @a = 1
  erb :show, :locals => {:v => 1}
end

post "/" do
  @frame = LiveFrame.basic_instance
  @frame.piece_plot
  @frame.execute(params[:way])
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
<%= @frame_decorator.counter_human_name %>手目
<%= @frame_decorator.current_player.location.mark_with_name %>番
<br/>
<form action="/" method="post">
次の手: <input name="way" value="" />
  <input type="submit" value="打" />
</form>
<br/>
<br/>
<%= @frame_decorator.to_html_board %>
)
end
