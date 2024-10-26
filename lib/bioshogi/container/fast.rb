# frozen-string-literal: true

module Bioshogi
  module Container
    class Fast
      include CoreMethods
      include PlayersMethods
      include SerializeMethods
      include ExecuteMethods

      def executor_class
        PlayerExecutor::WithoutAnalyzer
      end
    end
  end
end
