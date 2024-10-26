# frozen-string-literal: true

module Bioshogi
  module Container
    class Simple
      include CoreMethods
      include PlayersMethods
      include ExecuteMethods
      include SerializeMethods
      include TestMethods

      def executor_class
        PlayerExecutor::WithoutAnalyzer
      end
    end
  end
end
