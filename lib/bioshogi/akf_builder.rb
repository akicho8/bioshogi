# frozen-string-literal: true

module Bioshogi
  class AkfBuilder
    include Builder

    def self.default_params
      super.merge({
          :length                 => 12,
          :number_width           => 4,
          :header_skip            => false,
          :footer_skip            => false,
          :no_embed_if_time_blank => false, # 時間がすべて0ならタイムを指定しない
        })
    end

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    # def to_h
    #   {
    #     :header => @parser.header.to_h,
    #     :moves  => @parser.move_infos,
    #   }
    # end

    def to_h
      @parser.mediator_run_once
      @hv = {}
      @hv[:header] = @parser.header.to_h

      @chess_clock = ChessClock.new

      @hv[:moves] = @parser.mediator.hand_logs.collect.with_index { |e, i|
        @chess_clock.add(@parser.used_seconds_at(i))
        move = {
          index: i,
          **e.to_akf,
          **@chess_clock.last_clock.to_h,
        }
        # n = 0
        # if Bioshogi.if_starting_from_the_2_hand_second_is_also_described_from_2_hand_first_kif
        #   n += @parser.mediator.initial_state_turn_info.display_turn
        # end
        # s = e.to_kif(char_type: :formal_sheet)
        # s = @parser.mb_ljust(s, @params[:length])
        # s = "%*d %s %s" % [@params[:number_width], i.next, s, @chess_clock || ""]
        # s = s.rstrip + "\n"
        # if v = e.to_skill_set_kif_comment
        #   s += v
        # end
        # s
        move
      }

      # out << hand_log_body
      #
      # unless @params[:footer_skip]
      #   out << footer_content
      # end
      #
      # out.join

      @hv
    end

    private

    # def footer_content
    #   out = []
    #
    #   left_part = nil
    #   right_part = nil
    #
    #   if @parser.last_action_info.kif_word
    #     left_part = "%*d %s" % [
    #       @params[:number_width],
    #       # @parser.mediator.initial_state_turn_info.display_turn + @parser.mediator.hand_logs.size.next,
    #       @parser.mediator.hand_logs.size.next,
    #       @parser.mb_ljust(@parser.last_action_info.kif_word, @params[:length]),
    #     ]
    #   end
    #
    #   if true
    #     if @parser.last_status_params
    #       if used_seconds = @parser.last_status_params[:used_seconds]
    #         if @chess_clock
    #           @chess_clock.add(used_seconds)
    #           right_part = @chess_clock.to_s
    #         end
    #       end
    #     end
    #   end
    #
    #   if left_part
    #     out << "#{left_part} #{right_part}".rstrip + "\n"
    #   end
    #
    #   out << @parser.judgment_message + "\n"
    #   out << @parser.error_message_part
    #
    #   out
    # end
  end
end
