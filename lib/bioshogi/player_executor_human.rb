# frozen-string-literal: true

module Bioshogi
  class PlayerExecutorHuman < PlayerExecutorBase
    include HandLogsMod
    include MonitorMod
  end
end
