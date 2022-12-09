# -*- compile-command: "ruby -I../.. -rbioshogi -e Bioshogi::Explain::DistributionRatioGenerator.new.generate" -*-
# https://www.shogi-extend.com/api/swttars/distribution_ratio

require "faraday"

module Bioshogi
  module Explain
    class DistributionRatioGenerator
      def generate
        output_file.write(template % { body: body_hash.pretty_inspect.strip })
        puts "write: #{output_file}"
      end

      private

      def body_hash
        body = Faraday.get("https://www.shogi-extend.com/api/swars/distribution_ratio.json").body
        hash = JSON.parse(body)
        hash["items"].inject({}) {|a, e| a.merge(e["name"] => e.except("name").symbolize_keys) }
      end

      def output_file
        Pathname("#{__dir__}/distribution_ratio.rb").expand_path
      end

      def template
        o = []
        o << "# -*- frozen_string_literal: true -*-"
        o << "# #{__FILE__} から生成しているので編集するべからず"
        o << "module Bioshogi"
        o << "  module Explain"
        o << "    DistributionRatio = %{body}"
        o << "  end"
        o << "end"
        o.join("\n") + "\n"
      end
    end
  end
end
