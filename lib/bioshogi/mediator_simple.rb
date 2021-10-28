# frozen-string-literal: true

module Bioshogi
  class MediatorSimple
    include MediatorBase
    include MediatorPlayers
    include MediatorExecutor
    include MediatorSerializeMethods
    include MediatorMemento
    include MediatorTest

    def executor_class
      PlayerExecutorWithoutMonitor
    end
  end
end
