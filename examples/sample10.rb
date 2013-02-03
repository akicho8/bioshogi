# -*- coding: utf-8 -*-
# 盤面のHTML化

begin
  require_relative "../lib/bushido"
rescue LoadError
  require File.expand_path(File.join(File.dirname(__FILE__), "../lib/bushido"))
end

include Bushido

require "delegate"

class FrameDecorator < SimpleDelegator
  def to_html
    rows = Position::Vpos.ridge_length.times.collect{|y|
      tds = Position::Hpos.ridge_length.times.collect{|x|
        style = ""
        if soldier = board.surface[[x, y]]
          if soldier.player.location.white?
            style = "-moz-transform: rotate(180deg)"
          end
          cell = soldier.piece_current_name
        end
        "<td style=\"#{style}\">#{cell}</td>"
      }
      "<tr>#{tds.join("\n")}</tr>"
    }
    html = "<table>#{rows.join("\n")}</table>"
  end
end

frame = LiveFrame.basic_instance
frame.piece_plot
frame_decorator = FrameDecorator.new(frame)
puts frame_decorator.to_html
Pathname("_frame.html").open("w"){|f|f << frame_decorator.to_html}
