# frozen-string-literal: true
#
# 駒の移動情報定義用
#

module Bioshogi
  class Pvec < Array
    def flip_sign
      x, y = self
      self.class[-x, -y]
    end
  end

  # 銀桂などの1回進む駒用
  class OnceVector < Pvec
    def inspect
      "OV#{super}"
    end
  end

  # 飛香などの連続して進む駒用
  class RepeatVector < Pvec
    def inspect
      "RV#{super}"
    end
  end

  OV = OnceVector
  RV = RepeatVector
end
