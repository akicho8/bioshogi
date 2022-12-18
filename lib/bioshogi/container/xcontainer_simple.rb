# frozen-string-literal: true

module Bioshogi
  module Container
    class XcontainerSimple
      include CoreMethods
      include PlayersMethods
      include ExecuteMethods
      include SerializeMethods
      include TestMethods

      def executor_class
        PlayerExecutorWithoutMonitor
      end
    end
  end
end
