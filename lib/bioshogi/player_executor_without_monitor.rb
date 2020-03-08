# frozen-string-literal: true

module Bioshogi
  class PlayerExecutorWithoutMonitor < PlayerExecutorBase
    include HandLogsMod         # 配列ではなく最後の手だけを持ちたい
  end
end
