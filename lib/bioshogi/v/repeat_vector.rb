module Bioshogi
  class V
    # 飛香などの連続して進む駒用
    class RepeatVector < self
      def inspect
        "RV#{super}"
      end
    end
  end
end
