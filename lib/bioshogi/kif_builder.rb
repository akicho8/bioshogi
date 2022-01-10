# frozen-string-literal: true

module Bioshogi
  class KifBuilder
    include Builder
    include KakinokiBuilder

    HEADER_BODY_SEPARATOR = "手数----指手---------消費時間--"

    class << self
      def default_params
        super.merge({
            :hand_width       => 12,
            :number_width     => 4,
            :header_skip      => false,
            :footer_skip      => false,
            :time_embed_force => false, # 強制的に時間を含めるか？
          })
      end
    end

    private

    def build_setup
      if @params[:time_embed_force] || @parser.clock_exist?
        @chess_clock = ChessClock.new
      end
    end

    def body_header
      HEADER_BODY_SEPARATOR + "\n"
    end

    def body_hands
      @parser.mediator.hand_logs.collect.with_index { |e, i|
        if @chess_clock
          @chess_clock.add(@parser.used_seconds_at(i))
        end
        n = 0
        if Bioshogi.if_starting_from_the_2_hand_second_is_also_described_from_2_hand_first_kif
          n += @parser.mediator.initial_state_turn_info.display_turn
        end
        s = e.to_kif(char_type: :formal_sheet)
        s = mb_ljust(s, @params[:hand_width])
        s = "%*d %s %s" % [@params[:number_width], n + i.next, s, @chess_clock || ""]
        s = s.rstrip + "\n"
        if v = e.to_skill_set_kif_comment
          s += v
        end
        s
      }.join
    end

    def footer_content
      out = []

      left_part = nil
      right_part = nil

      if @parser.last_action_info.kif_word
        left_part = "%*d %s" % [
          @params[:number_width],
          # @parser.mediator.initial_state_turn_info.display_turn + @parser.mediator.hand_logs.size.next,
          @parser.mediator.hand_logs.size.next,
          mb_ljust(@parser.last_action_info.kif_word, @params[:hand_width]),
        ]
      end

      if true
        if @parser.last_action_params
          if used_seconds = @parser.last_action_params[:used_seconds]
            if @chess_clock
              @chess_clock.add(used_seconds)
              right_part = @chess_clock.to_s
            end
          end
        end
      end

      if left_part
        out << "#{left_part} #{right_part}".rstrip + "\n"
      end

      out
    end
  end
end
