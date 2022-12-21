# frozen-string-literal: true
#
# 駒の移動情報定義用
#

# require "matrix"

module Bioshogi
  class PieceVector < Array
    def flip_sign
      x, y = self
      self.class[-x, -y]
    end
  end

  # 銀桂などの1回進む駒用
  class OnceVector < PieceVector
    def inspect
      "OV#{super}"
    end
  end

  # 飛香などの連続して進む駒用
  class RepeatVector < PieceVector
    def inspect
      "RV#{super}"
    end
  end

  OV = OnceVector
  RV = RepeatVector
end
