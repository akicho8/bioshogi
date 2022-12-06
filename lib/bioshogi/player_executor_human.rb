# frozen-string-literal: true

module Bioshogi
  class PlayerExecutorHuman < PlayerExecutorBase
    include HandLogsMod
    include Explain::MonitorMod
  end
end
