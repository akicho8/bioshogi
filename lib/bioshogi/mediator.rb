# frozen-string-literal: true

module Bioshogi
  class Mediator
    include MediatorBase
    include MediatorPlayers
    include MediatorSerializers
    include MediatorExecutor
    include MediatorVariables
    include MediatorTest
    include MediatorMemento
  end
end
