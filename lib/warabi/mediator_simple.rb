# frozen-string-literal: true

module Warabi
  class MediatorSimple
    include MediatorBase
    include MediatorParams
    include MediatorPlayers
    include MediatorBoard
    include MediatorExecutor
    include MediatorSerializers
    include MediatorTest
    include MediatorMemento

    def execute(str, **options)
      options = {
        executor_class: PlayerExecutorCpu,
      }.merge(options)

      InputParser.scan(str).each do |str|
        current_player.execute(str, options)
      end
    end
  end
end
