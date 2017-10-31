# 盤面のHTML化

require "./example_helper"

require "delegate"

class MediatorDecorator < SimpleDelegator
  def to_html
    rows = Position::Vpos.size.times.collect{|y|
      tds = Position::Hpos.size.times.collect{|x|
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

mediator = Mediator.start
mediator.piece_plot
frame_decorator = MediatorDecorator.new(mediator)
puts frame_decorator.to_html
Pathname("_frame.html").open("w"){|f|f << frame_decorator.to_html}
# `open _frame.html`
