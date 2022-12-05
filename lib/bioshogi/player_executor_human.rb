# frozen-string-literal: true

module Bioshogi
  class PlayerExecutorHuman < PlayerExecutorBase
    include HandLogsMod
    include Xtech::MonitorMod
  end
end
