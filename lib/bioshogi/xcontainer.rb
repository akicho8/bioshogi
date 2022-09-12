# frozen-string-literal: true

module Bioshogi
  class Xcontainer
    include XcontainerBase
    include XcontainerPlayers
    include XcontainerSerializeMethods
    include XcontainerExecutor
    include XcontainerVariables
    include XcontainerTest
    include XcontainerMemento
  end
end
