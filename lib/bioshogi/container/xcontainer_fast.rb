# frozen-string-literal: true

module Bioshogi
  module Container
    class XcontainerFast
      include CoreMethods
      include PlayersMethods
      include ExecuteMethods

      def executor_class
        PlayerExecutorWithoutMonitor
      end
    end
  end
end
