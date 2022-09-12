# frozen-string-literal: true

module Bioshogi
  class BodBuilder
    include Builder
    include KakinokiBuilder

    def to_s
      @parser.xcontainer_run_once
      @parser.xcontainer.to_bod(@params)
    end
  end
end
