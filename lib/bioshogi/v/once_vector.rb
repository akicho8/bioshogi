module Bioshogi
  class V
    # 銀桂などの1回進む駒用
    class OnceVector < self
      def inspect
        "OV#{super}"
      end
    end
  end
end
