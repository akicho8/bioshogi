module Bioshogi
  module PlayerExecutor
    class WithoutAnalyzer < Base
      include HandLogsMod  # FIXME: 配列ではなく最後の手だけを持ちたい
    end
  end
end
