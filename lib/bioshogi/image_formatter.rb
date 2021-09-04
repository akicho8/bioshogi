# 画像変換
#
#  info = Parser.parse(...)
#  ImageFormatter.new(info).to_png
#

module Bioshogi
  class ImageFormatter < BinaryFormatter
  end

  require "bioshogi/image_formatter/base"
  require "bioshogi/image_formatter/layer_methods"
  require "bioshogi/image_formatter/board_methods"
  require "bioshogi/image_formatter/soldier_methods"
  require "bioshogi/image_formatter/stand"
  require "bioshogi/image_formatter/pentagon"
  require "bioshogi/image_formatter/helper"

  require "bioshogi/image_formatter/color_theme_info"
  require "bioshogi/image_formatter/canvas_pattern_info"
  require "bioshogi/image_formatter/font_theme_info"
end
