# 画像変換
#
#  info = Parser.parse(...)
#  ImageFormatter.new(info).to_png
#

module Bioshogi
  class ImageFormatter < BinaryFormatter
  end

  require "bioshogi/image_formatter/base"
  require "bioshogi/image_formatter/board"
  require "bioshogi/image_formatter/stand"
  require "bioshogi/image_formatter/pentagon"

  require "bioshogi/image_formatter/color_theme_info"
end
