module Bioshogi
  module Parser
    concern :ImgFormatter do
      def to_img(**options)
        o = GazoFormatter.new(self, options)
        o.render
        o
      end
    end
  end
end
