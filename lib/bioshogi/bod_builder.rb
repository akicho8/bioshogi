# frozen-string-literal: true

module Bioshogi
  class BodBuilder
    include Builder
    include KakinokiBuilder

    def to_s
      @exporter.xcontainer_run_once
      @exporter.xcontainer.to_bod(@params)
    end
  end
end
