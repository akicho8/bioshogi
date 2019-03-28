# frozen-string-literal: true

module Warabi
  concern :MediatorExecutor do
    # MediatorSimple では使ってないメソッド
    concerning :HumanMethods do
      included do
        delegate :to_kif_a, :to_ki2_a, :to_kif_oneline, to: :hand_logs
      end

      attr_writer :kill_counter

      def kill_counter
        @kill_counter ||= 0
      end

      def hand_logs
        @hand_logs ||= HandLogs.new([])
      end
    end

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
