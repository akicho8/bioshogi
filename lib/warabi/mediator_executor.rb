# frozen-string-literal: true

module Warabi
  concern :MediatorExecutor do
    def execute(str, **options)
      InputParser.scan(str).each do |str|
        current_player.execute(str, options)
      end
    end
  end
end
