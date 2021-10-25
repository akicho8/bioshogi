module Bioshogi
  concern :Builder do
    included do
    end

    class_methods do
      def default_params
        {}
      end
    end
  end
end
