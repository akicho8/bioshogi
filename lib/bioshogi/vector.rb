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

  ################################################################################ for ImageFormatter

  require "matrix"

  class V < Vector
    def self.one
      self[1, 1]
    end

    def self.half
      self[0.5, 0.5]
    end

    def x
      self[0]
    end

    def y
      self[1]
    end
  end

  class Rect < Vector
    def w
      self[0]
    end

    def h
      self[1]
    end
  end
end
