# 盤面のHTML化
require "./example_helper"

require "delegate"
require "action_view"

class MediatorDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  attr_accessor :output_buffer

  def to_html
    tag.table(border: true) do
      Position::Vpos.size.times.collect { |y|
        tag.tr {
          Position::Hpos.size.times.collect { |x|
            style = nil
            cell = ""
            if soldier = board.surface[[x, y]]
              style = soldier.player.location.style_transform
              cell = soldier.piece_current_name
            end
            tag.td(cell, style: style)
          }.join.html_safe
        }
      }.join.html_safe
    end
  end
end

mediator = Mediator.start
mediator.piece_plot
frame_decorator = MediatorDecorator.new(mediator)
puts frame_decorator.to_html
Pathname("_frame.html").write(frame_decorator.to_html)
`open _frame.html`
