# frozen-string-literal: true

module Bioshogi
  module Formatter
    class KifBuilder
      include Builder
      include KifKi2Shared

      HEADER_BODY_SEPARATOR = "手数----指手---------消費時間--"

      class << self
        def default_params
          super.merge({
              :hand_width       => 12,
              :number_width     => 4,
              :time_embed_force => false, # 強制的に時間を含めるか？
            })
        end
      end

      private

      def build_before
        if @params[:time_embed_force] || @formatter.pi.clock_exist?
          @main_clock = MainClock.new
        end
      end

      def body_header
        HEADER_BODY_SEPARATOR + "\n"
      end

      def body_hands
        @formatter.container.hand_logs.collect.with_index { |e, i|
          if @main_clock
            @main_clock.add(@formatter.pi.used_seconds_at(i))
          end
          s = e.to_kif(char_type: :formal_sheet)
          s = mb_ljust(s, @params[:hand_width])
          n = "%*d" % [@params[:number_width], i.next]
          s = [n, s, @main_clock].compact.join(" ")
          s = s.rstrip + "\n"
          if v = e.kif_comment
            s += v
          end
          s
        }.join
      end

      def footer_content
        out = []

        left_part = nil
        right_part = nil

        if @formatter.pi.last_action_info2
          if kakinoki_word = @formatter.pi.last_action_info2.kakinoki_word
            left_part = "%*d %s" % [
              @params[:number_width],
              @formatter.container.hand_logs.size.next,
              mb_ljust(kakinoki_word, @params[:hand_width]),
            ]
          end

          if used_seconds = @formatter.pi.last_action_params[:used_seconds]
            if @main_clock
              @main_clock.add(used_seconds)
              right_part = @main_clock.to_s
            end
          end

          if left_part
            out << "#{left_part} #{right_part}".rstrip + "\n"
          end
        end

        out
      end
    end
  end
end
