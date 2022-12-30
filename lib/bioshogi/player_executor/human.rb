module Bioshogi
  module PlayerExecutor
    class Human < Base
      include HandLogsMod
      include Explain::MonitorMod
    end
  end
end
