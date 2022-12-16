# 画像変換
#
#  Parser.parse(...).to_png
#
module Bioshogi
  module ScreenImage
    def self.renderer(*args)
      Renderer.new(*args)
    end
  end
end
