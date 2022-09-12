# frozen-string-literal: true

module Bioshogi
  class XcontainerFast
    include XcontainerBase
    include XcontainerPlayers
    include XcontainerExecutor

    def executor_class
      PlayerExecutorWithoutMonitor
    end
  end
end
