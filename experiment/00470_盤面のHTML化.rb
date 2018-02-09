# 盤面のHTML化
require "./example_helper"

require "delegate"
require "action_view"

class MediatorDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  attr_accessor :output_buffer

  def to_html
    tag.table(border: true) do
      Position::Vpos.dimension.times.collect { |y|
        tag.tr {
          Position::Hpos.dimension.times.collect { |x|
            style = nil
            cell = ""
            if soldier = board.surface[[x, y]]
              style = soldier.player.location.style_transform
              cell = soldier.any_name
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
decorator = MediatorDecorator.new(mediator)
puts decorator.to_html
Pathname("_frame.html").write(decorator.to_html)
`open _frame.html`
# >> <table border="true"><tr><td style="transform: rotate(180deg)">香</td><td style="transform: rotate(180deg)">桂</td><td style="transform: rotate(180deg)">銀</td><td style="transform: rotate(180deg)">金</td><td style="transform: rotate(180deg)">玉</td><td style="transform: rotate(180deg)">金</td><td style="transform: rotate(180deg)">銀</td><td style="transform: rotate(180deg)">桂</td><td style="transform: rotate(180deg)">香</td></tr><tr><td></td><td style="transform: rotate(180deg)">飛</td><td></td><td></td><td></td><td></td><td></td><td style="transform: rotate(180deg)">角</td><td></td></tr><tr><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>歩</td><td>歩</td><td>歩</td><td>歩</td><td>歩</td><td>歩</td><td>歩</td><td>歩</td><td>歩</td></tr><tr><td></td><td>角</td><td></td><td></td><td></td><td></td><td></td><td>飛</td><td></td></tr><tr><td>香</td><td>桂</td><td>銀</td><td>金</td><td>玉</td><td>金</td><td>銀</td><td>桂</td><td>香</td></tr></table>
