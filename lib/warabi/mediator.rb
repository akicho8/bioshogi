# frozen-string-literal: true

module Warabi
  class Mediator
    include MediatorBase
    include MediatorPlayers
    include MediatorBoard
    include MediatorSerializers
    include MediatorExecuter
    include MediatorVariables
    include MediatorTest
  end
end
