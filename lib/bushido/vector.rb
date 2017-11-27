# -*- compile-command: "bundle exec rspec ../../spec/vector_spec.rb" -*-
# frozen-string-literal: true
#
# 駒の移動ベクトル定義用
#

module Bushido
  class Vector < Array
    def reverse_sign
      x, y = self
      self.class[-x, -y]
    end
  end

  # 銀桂などの1回進むだけの移動ベクトル用
  class OnceVector < Vector
    def inspect
      "OV#{super}"
    end
  end

  # 香や角などの連続して進める駒の移動ベクトル用
  class RepeatVector < Vector
    def inspect
      "RV#{super}"
    end
  end

  OV = OnceVector
  RV = RepeatVector
end
