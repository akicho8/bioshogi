# -*- compile-command: "ruby base.rb kif_normalizer" -*-

module Bushido
  module Cli
    class KifNormalizerCommand < Base
      def self.command_name
        "KIFの正規化"
      end

      def execute
        @args.each do |file|
          puts Bushido.parse_file(file).to_kif
        end
      end
    end
  end
end
