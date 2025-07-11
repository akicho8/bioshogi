# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class OutbreakDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
        end
      end
    end
  end
end
