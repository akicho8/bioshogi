# frozen-string-literal: true

module Bioshogi
  class Xcontainer
    include XcontainerBase
    include XcontainerPlayers
    include XcontainerBoard
    include XcontainerSerializeMethods
    include XcontainerExecutor
    include XcontainerVariables
    include XcontainerTest
  end
end
