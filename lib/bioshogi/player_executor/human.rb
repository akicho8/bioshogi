module Bioshogi
  module PlayerExecutor
    class Human < Base
      include HandLogsMod
      include Analysis::MonitorMod
    end
  end
end
