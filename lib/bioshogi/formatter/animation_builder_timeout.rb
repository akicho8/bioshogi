module Bioshogi
  module Formatter
    concern :AnimationBuilderTimeout do
      private

      def tob(name, expires_in = 30, &block)
        begin
          t = Time.now
          logger.info { "[#{name}][begin]" }
          begin
            Timeout::timeout(expires_in, &block)
          rescue Timeout::Error => error
            raise Timeout::Error, "[#{name}] #{error.message}"
          end
        ensure
          t = (Time.now - t).round
          logger.info { "[#{name}][end][#{t}s]" }
        end
      end

      def heavy_tob(name, &block)
        tob(name, 60, &block)
      end
    end
  end
end
