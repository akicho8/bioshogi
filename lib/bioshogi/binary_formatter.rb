module Bioshogi
  class BinaryFormatter
    class << self
      def assert_valid_keys(params)
        params.assert_valid_keys(all_options.keys)
      end

      def all_options
        AnimationFormatter.default_params.merge(ImageFormatter.default_params)
      end

      def render(*args)
        new(*args).tap(&:render)
      end
    end
  end
end
