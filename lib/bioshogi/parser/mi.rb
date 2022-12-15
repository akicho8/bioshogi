# frozen-string-literal: true

module Bioshogi
  module Parser
    class Mi
      attr_accessor :move_infos
      attr_accessor :first_comments
      attr_accessor :board_source
      attr_accessor :last_action_params
      attr_accessor :header

      def initialize
        @move_infos     = []
        @first_comments = []
        @board_source   = nil
        @last_action_params = nil
        @header = Header.new
      end
    end
  end
end
