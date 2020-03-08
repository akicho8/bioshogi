# frozen-string-literal: true

module Bioshogi
  class MediatorFast
    include MediatorBase
    include MediatorPlayers
    include MediatorExecutor

    def executor_class
      PlayerExecutorWithoutMonitor
    end
  end
end
