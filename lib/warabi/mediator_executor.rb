# frozen-string-literal: true

module Warabi
  concern :MediatorExecutor do
    attr_writer :kill_counter

    delegate :to_kif_a, :to_ki2_a, to: :hand_logs

    def kill_counter
      @kill_counter ||= 0
    end

    def hand_logs
      @hand_logs ||= HandLogs.new([])
    end

    def execute(str, **options)
      InputParser.scan(str).each do |str|
        current_player.execute(str, options)
        turn_info.counter += 1
      end
    end
  end
end
