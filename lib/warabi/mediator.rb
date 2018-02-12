# frozen-string-literal: true

module Warabi
  class Mediator
    include MediatorBase
    include MediatorPlayers
    include MediatorBoard
    include MediatorSerializers
    include MediatorExecutor
    include MediatorVariables
    include MediatorTest
  end
end
