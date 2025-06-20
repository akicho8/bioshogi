module Bioshogi
  module Parser
    class Inspector
      def initialize(parser)
        @parser = parser
      end

      def inspect
        av = []

        if @parser.pi.board_source
          av << "* pi.board_source"
          av << @parser.pi.board_source.strip
          av << " "
        end

        av << "* attributes"
        av << {
          :force_preset_info => @parser.pi.force_preset_info,
          :force_location    => @parser.pi.force_location,
          :force_handicap    => @parser.pi.force_handicap,
        }.to_t.strip
        av << " "

        av << "* pi.header"
        av << @parser.pi.header.inspect.strip
        av << " "

        if @parser.pi.board_source
          av << "* @parser.pi.board_source"
          av << @parser.pi.board_source.strip
          av << " "
        end

        av << "* pi.move_infos"
        av << @parser.pi.move_infos.to_t.strip
        av << " "

        av << "* @parser.pi.final_result.last_action_key"
        av << @parser.pi.final_result.last_action_key.inspect
        av << " "

        av << "* @parser.pi.last_used_seconds"
        av << @parser.pi.last_used_seconds.inspect
        av << " "

        av.join("\n").strip
      end
    end
  end
end
