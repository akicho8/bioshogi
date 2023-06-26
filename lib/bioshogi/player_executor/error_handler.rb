# frozen-string-literal: true

module Bioshogi
  module PlayerExecutor
    class ErrorHandler
      def initialize(context, error)
        @context = context
        @error = error
      end

      def call
        raise error_object_create
      end

      private

      def error_object_create
        @error[:error_class].new(error_message).tap do |e|
          e.instance_variable_set(:@container, @context.container)
          e.define_singleton_method(:container) { @container }
          e.instance_variable_set(:@input, @context.input)
          e.define_singleton_method(:input) { @input }
        end
      end

      def error_message
        attributes = {
          "手番"   => @context.player.call_name,
          "指し手" => @context.input.source,
          "棋譜"   => @context.container.hand_logs.to_kif_a.join(" "),
        }

        message = @error[:message]

        # 一行に情報をつめこむ場合
        if false
          message = ["[#{@context.player.call_name}][#{@context.container.turn_info.turn_offset.next}手目][#{@context.input.source}]", message].join
        end

        str = []
        str << message
        str.concat(attributes.collect { |*e| e.join(": ") })
        str << ""
        str << @context.container.to_bod
        str = str.collect(&:rstrip).join("\n")
      end
    end
  end
end
