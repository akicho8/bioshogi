# frozen-string-literal: true

module Bioshogi
  class YomiageBuilder
    include Builder

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_s
      @parser.mediator.to_yomiage(@params)
    end
  end
end
