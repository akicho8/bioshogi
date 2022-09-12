# frozen-string-literal: true

module Bioshogi
  class YomiageBuilder
    include Builder

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_s
      @parser.xcontainer.to_yomiage(@params)
    end

    def to_a
      @parser.xcontainer.to_yomiage_list(@params)
    end
  end
end
