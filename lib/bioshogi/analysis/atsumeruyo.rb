# frozen-string-literal: true

module Bioshogi
  module Analysis
    class Atsumeruyo
      attr_accessor :container

      def initialize(container)
        @container = container
      end

      def call
        # ここで hand_log.tag_bundle を収集しようかと思ったがやめ
        # container.hand_logs.each do |hand_log|
        # end
      end
    end
  end
end
