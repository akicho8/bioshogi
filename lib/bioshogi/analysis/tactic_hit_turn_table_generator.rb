module Bioshogi
  module Analysis
    class TacticHitTurnTableGenerator
      def initialize(options = {})
        @options = {
          verbose: true,
        }.merge(options)
      end

      def call
        output_file.write(template % { body: body })
        if @options[:verbose]
          puts "write: #{output_file}"
        end
      end

      def to_h
        av = Analysis::TagIndex.values.collect do |e|
          turn = nil
          e.static_kif_info.formatter.container.hand_logs.each.with_index do |hand_log, i|
            if hand_log.tag_bundle.has_skill?(e)
              turn = i.next
              break
            end
          end
          [e, turn]
        end

        av.sort_by { |e, turn| [turn || 0, e.name] }.collect { |e, turn| [e.name, turn] }.to_h
      end

      def body
        str = to_h.inspect
        str = str.gsub(/{/, "")
        str = str.gsub(/}/, ",")
        str = str.gsub(/\s*,\s*/, ",\n")
        str = str.gsub(/^(?=")/, "  " * 3)
        str = str.gsub("=>", " => ")
        str = str.gsub(/ "/, ':"')
        str = str.rstrip
      end

      def output_file
        Pathname("#{__dir__}/tactic_hit_turn_table.rb").expand_path
      end

      def template
        o = []
        o << "# -*- frozen_string_literal: true -*-"
        o << ""
        o << "# #{__FILE__} から生成しているので編集するべからず"
        o << "# 手数が nil のものは最後に判定してるため成立した手数を正確に知ることができない"
        o << "module Bioshogi"
        o << "  module Analysis"
        o << "    TacticHitTurnTable = {"
        o << "%{body}"
        o << "    }"
        o << "  end"
        o << "end"
        o.join("\n") + "\n"
      end
    end
  end
end
