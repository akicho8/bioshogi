# -*- compile-command: "ruby -I../.. -rbioshogi -e Bioshogi::Explain::DistributionRatioGenerator.new.generate" -*-
# https://www.shogi-extend.com/api/swttars/distribution_ratio

require "faraday"

module Bioshogi
  module Explain
    class DistributionRatioGenerator
      SOURCE_URL = "https://www.shogi-extend.com/api/swars/distribution_ratio.json"

      def generate
        output_file.write(template % { body: body_hash.pretty_inspect.strip })
        puts "write: #{output_file}"
      end

      private

      def body_hash
        response = Faraday.get(SOURCE_URL)
        hash = JSON.parse(response.body, symbolize_names: true)
        validate(hash)
        hash[:items].each do |e|
          e[:name] = e[:name].to_sym
          e[:rarity_key] = e[:rarity_key].to_sym
        end
        hash[:items].inject({}) {|a, e| a.merge(e[:name].to_sym => e) }
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

      def validate(hash)
        unless hash[:items].sum { |e| e[:emission_ratio] } == 1.0
          raise "must not happen"
        end
      end
    end
  end
end
