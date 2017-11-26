# -*- compile-command: "ruby base.rb kif_normalizer" -*-
# frozen-string-literal: true

module Bushido
  module Cli
    class KifNormalizerCommand < Base
      self.command_name = "KIFの正規化"

      def execute
        @args.each do |file|
          puts Parser.parse_file(file).to_kif
        end
      end
    end
  end
end
