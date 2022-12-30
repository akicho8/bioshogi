# frozen-string-literal: true

module Bioshogi
  module Container
    class Fast
      include CoreMethods
      include PlayersMethods
      include ExecuteMethods

      def executor_class
        PlayerExecutor::WithoutMonitor
      end
    end
  end
end
