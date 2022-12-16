# 画像変換
#
#  info = Parser.parse(...)
#  ImageRenderer.new(info).to_png
#

module Bioshogi
  module ImageRenderer
    def self.new(*args)
      Main.new(*args)
    end
  end
end
