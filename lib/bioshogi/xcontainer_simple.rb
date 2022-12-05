# frozen-string-literal: true

module Bioshogi
  class XcontainerSimple
    include XcontainerBase
    include XcontainerPlayers
    include XcontainerExecutor
    include XcontainerSerializer
    include XcontainerMemento
    include XcontainerTest

    def executor_class
      PlayerExecutorWithoutMonitor
    end
  end
end
