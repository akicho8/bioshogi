# frozen-string-literal: true

module Bioshogi
  class BodBuilder
    include Builder
    include KakinokiBuilder

    def to_s
      @parser.mediator_run_once
      @parser.mediator.to_bod(@params)
    end
  end
end
