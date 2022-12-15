module Bioshogi
  module Parser
    class Inspector
      def initialize(parser)
        @parser = parser
      end

      def inspect
        av = []

        if @parser.board_source
          av << "* board_source"
          av << @parser.board_source.strip
          av << " "
        end

        av << "* attributes"
        av << {
          :force_preset_info => @parser.force_preset_info,
          :balance_info      => @parser.balance_info,
          :force_location    => @parser.force_location,
          :force_handicap    => @parser.force_handicap,
        }.to_t.strip
        av << " "

        av << "* header"
        av << @parser.header.inspect.strip
        av << " "

        if @parser.board_source
          av << "* @parser.board_source"
          av << @parser.board_source.strip
          av << " "
        end

        av << "* mi.move_infos"
        av << @parser.mi.move_infos.to_t.strip
        av << " "

        av << "* @parser.last_action_params"
        av << @parser.last_action_params.to_t.strip
        av << " "

        av.join("\n").strip
      end
    end
  end
end
