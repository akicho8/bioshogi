# 盤面のHTML化
require "./setup"

require "delegate"
require "action_view"

class Container::ContainerDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  attr_accessor :output_buffer

  def to_html
    tag.table(border: true) do
      Dimension::Row.dimension_size.times.collect { |y|
        tag.tr {
          Dimension::Column.dimension_size.times.collect { |x|
            style = nil
            cell = ""
            if soldier = board.lookup([x, y])
              angle = soldier.location.key == :white ? 180 : 0
              style = "transform: rotate(#{angle}deg)"
              cell = soldier.any_name
            end
            tag.td(cell, style: style)
          }.join.html_safe
        }
      }.join.html_safe
    end
  end
end

container = Container::Basic.start
decorator = Container::ContainerDecorator.new(container)
puts decorator.to_html
Pathname("_frame.html").write(decorator.to_html)
`open _frame.html`
# >> <table border="true"><tr><td style="transform: rotate(180deg)">香</td><td style="transform: rotate(180deg)">桂</td><td style="transform: rotate(180deg)">銀</td><td style="transform: rotate(180deg)">金</td><td style="transform: rotate(180deg)">玉</td><td style="transform: rotate(180deg)">金</td><td style="transform: rotate(180deg)">銀</td><td style="transform: rotate(180deg)">桂</td><td style="transform: rotate(180deg)">香</td></tr><tr><td></td><td style="transform: rotate(180deg)">飛</td><td></td><td></td><td></td><td></td><td></td><td style="transform: rotate(180deg)">角</td><td></td></tr><tr><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td><td style="transform: rotate(180deg)">歩</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td style="transform: rotate(0deg)">歩</td><td style="transform: rotate(0deg)">歩</td><td style="transform: rotate(0deg)">歩</td><td style="transform: rotate(0deg)">歩</td><td style="transform: rotate(0deg)">歩</td><td style="transform: rotate(0deg)">歩</td><td style="transform: rotate(0deg)">歩</td><td style="transform: rotate(0deg)">歩</td><td style="transform: rotate(0deg)">歩</td></tr><tr><td></td><td style="transform: rotate(0deg)">角</td><td></td><td></td><td></td><td></td><td></td><td style="transform: rotate(0deg)">飛</td><td></td></tr><tr><td style="transform: rotate(0deg)">香</td><td style="transform: rotate(0deg)">桂</td><td style="transform: rotate(0deg)">銀</td><td style="transform: rotate(0deg)">金</td><td style="transform: rotate(0deg)">玉</td><td style="transform: rotate(0deg)">金</td><td style="transform: rotate(0deg)">銀</td><td style="transform: rotate(0deg)">桂</td><td style="transform: rotate(0deg)">香</td></tr></table>
