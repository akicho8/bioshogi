# 盤面のHTML化
require "./example_helper"

require "delegate"
require "action_view"

class MediatorDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  attr_accessor :output_buffer

  def to_html
    tag.table(border: true) do
      Dimension::Xplace.dimension.times.collect { |y|
        tag.tr {
          Dimension::Yplace.dimension.times.collect { |x|
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

mediator = Mediator.start
decorator = MediatorDecorator.new(mediator)
puts decorator.to_html
Pathname("_frame.html").write(decorator.to_html)
`open _frame.html`
# >> <table border="true"><tr><td style="transform: rotate(180eg)">香</td><td style="transform: rotate(180eg)">桂</td><td style="transform: rotate(180eg)">銀</td><td style="transform: rotate(180eg)">金</td><td style="transform: rotate(180eg)">玉</td><td style="transform: rotate(180eg)">金</td><td style="transform: rotate(180eg)">銀</td><td style="transform: rotate(180eg)">桂</td><td style="transform: rotate(180eg)">香</td></tr><tr><td></td><td style="transform: rotate(180eg)">飛</td><td></td><td></td><td></td><td></td><td></td><td style="transform: rotate(180eg)">角</td><td></td></tr><tr><td style="transform: rotate(180eg)">歩</td><td style="transform: rotate(180eg)">歩</td><td style="transform: rotate(180eg)">歩</td><td style="transform: rotate(180eg)">歩</td><td style="transform: rotate(180eg)">歩</td><td style="transform: rotate(180eg)">歩</td><td style="transform: rotate(180eg)">歩</td><td style="transform: rotate(180eg)">歩</td><td style="transform: rotate(180eg)">歩</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td style="transform: rotate(0eg)">歩</td><td style="transform: rotate(0eg)">歩</td><td style="transform: rotate(0eg)">歩</td><td style="transform: rotate(0eg)">歩</td><td style="transform: rotate(0eg)">歩</td><td style="transform: rotate(0eg)">歩</td><td style="transform: rotate(0eg)">歩</td><td style="transform: rotate(0eg)">歩</td><td style="transform: rotate(0eg)">歩</td></tr><tr><td></td><td style="transform: rotate(0eg)">角</td><td></td><td></td><td></td><td></td><td></td><td style="transform: rotate(0eg)">飛</td><td></td></tr><tr><td style="transform: rotate(0eg)">香</td><td style="transform: rotate(0eg)">桂</td><td style="transform: rotate(0eg)">銀</td><td style="transform: rotate(0eg)">金</td><td style="transform: rotate(0eg)">玉</td><td style="transform: rotate(0eg)">金</td><td style="transform: rotate(0eg)">銀</td><td style="transform: rotate(0eg)">桂</td><td style="transform: rotate(0eg)">香</td></tr></table>
