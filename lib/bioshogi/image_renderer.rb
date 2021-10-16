# 画像変換
#
#  info = Parser.parse(...)
#  ImageRenderer.new(info).to_png
#

module Bioshogi
  class ImageRenderer
  end

  require "bioshogi/image_renderer/base"
  require "bioshogi/image_renderer/layer_methods"
  require "bioshogi/image_renderer/board_methods"
  require "bioshogi/image_renderer/soldier_methods"
  require "bioshogi/image_renderer/stand"
  require "bioshogi/image_renderer/pentagon"
  require "bioshogi/image_renderer/helper"

  require "bioshogi/image_renderer/palette_info"
  require "bioshogi/image_renderer/color_theme_info"
  require "bioshogi/image_renderer/canvas_pattern_info"
  require "bioshogi/image_renderer/font_theme_info"
end
