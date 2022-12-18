# frozen-string-literal: true

module Bioshogi
  module Container
    concern :ExecuteMethods do
      # Simple では使ってないメソッド
      concerning :HumanMethods do
        included do
          delegate :to_kif_a, :to_ki2_a, :to_kif_oneline, to: :hand_logs
        end

        attr_writer :kill_count      # 駒を取った回数
        attr_accessor :critical_turn # 最初の駒が取られる直前の手数           (avg: 21.6328)
        attr_accessor :outbreak_turn # 「歩と角」を除く駒が取られる直前の手数 (avg: 41.8402)

        def kill_count
          @kill_count ||= 0
        end

        def hand_logs
          @hand_logs ||= HandLogs.new([])
        end
      end

      def execute(str, options = {})
        options = {
          executor_class: executor_class,
        }.merge(options)

        InputParser.scan(str).each do |str|
          current_player.execute(str, options)
        end
      end

      def executor_class
        PlayerExecutor::Human
      end
    end
  end
end
