# -*- compile-command: "bundle exec rspec ../../spec/vector_spec.rb" -*-
#
# 駒の移動ベクトル定義用
#

module Bushido
  # 歩などは一歩進んで終わりなのでこちらで定義
  class Vector < Array
    def reverse_sign
      x, y = self
      self.class[-x, -y]
    end
  end

  class OnceVector < Vector
    def inspect
      "OV#{super}"
    end
  end

  # 香などは繰り返して進むのでこちらで定義
  class RepeatVector < Vector
    def inspect
      "RV#{super}"
    end
  end

  OV = OnceVector
  RV = RepeatVector
end
