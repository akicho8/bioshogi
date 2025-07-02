# frozen-string-literal: true

module Bioshogi
  module Container
    concern :ExecuteMethods do
      # Simple では使ってないメソッド
      concerning :HumanMethods do
        included do
          delegate :to_kif_a, :to_ki2_a, :to_kif_oneline, to: :hand_logs
        end

        attr_accessor :kill_count      # 総キル数
        attr_accessor :critical_turn # 最初の駒が取られる直前の手数           (avg: 22.6328)
        attr_accessor :outbreak_turn # 「歩と角」を除く駒が取られる直前の手数 (avg: 41.8402)

        def tyuuban_ikou
          outbreak_turn
        end

        def joban
          !outbreak_turn
        end

        def kill_count
          @kill_count ||= 0
        end

        def hand_logs
          @hand_logs ||= HandLogs.new([])
        end
      end

      def before_execute_all
      end

      def execute(str, options = {})
        options = {
          executor_class: executor_class,
        }.merge(options)

        InputParser.scan(str).each do |str|
          current_player.execute(str, options)
        end
      end

      def after_execute_all
        if params[:analysis_feature]
          Analysis::Atsumeruyo.new(self).call
          Analysis::FinalizeTagDetector.new(self).call
        end
      end

      def executor_class
        PlayerExecutor::Human
      end

      def to_header_shared_h
        if params[:analysis_feature]
          {
            "接触"     => critical_turn.try { "#{self}手目" },
            "開戦"     => outbreak_turn.try { "#{self}手目" },
            "総手数"   => "#{turn_info.display_turn}手",
            "総キル数" => "#{kill_count}キル",
          }
        else
          {}
        end
      end
    end
  end
end
