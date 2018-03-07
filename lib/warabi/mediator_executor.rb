# frozen-string-literal: true

module Warabi
  concern :MediatorExecutor do
    def execute(str, **options)
      options = {
        executor_class: executor_class,
      }.merge(options)

      InputParser.scan(str).each do |str|
        current_player.execute(str, options)
      end
    end

    def executor_class
      PlayerExecutorHuman
    end
  end
end
