# frozen-string-literal: true

module Bioshogi
  class SfenBuilder
    include Builder

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_s
      @parser.mediator.to_sfen(@params)
    end
  end
end
