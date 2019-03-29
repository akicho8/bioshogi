# frozen-string-literal: true

module Bioshogi
  class MediatorSimple
    include MediatorBase
    include MediatorPlayers
    include MediatorExecutor
    include MediatorSerializers
    include MediatorMemento
    include MediatorTest

    def executor_class
      PlayerExecutorCpu
    end
  end
end
