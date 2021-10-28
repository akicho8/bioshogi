# frozen-string-literal: true

module Bioshogi
  class SfenBuilder
    include Builder

    def self.default_params
      super.merge({
          :startpos_embed => true, # なるべく startpos に変換する
        })
    end

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_s
      @parser.mediator.to_history_sfen(@params)
    end
  end
end
