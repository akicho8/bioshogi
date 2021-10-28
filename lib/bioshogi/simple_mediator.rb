# frozen-string-literal: true

module Bioshogi
  class Mediator
    include MediatorBase
    include MediatorPlayers
    include MediatorBoard
    include MediatorSerializeMethods
    include MediatorExecutor
    include MediatorVariables
    include MediatorTest
  end
end
