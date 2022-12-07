# -*- compile-command: "ruby -I../.. -rbioshogi -e Bioshogi::Explain::TacticHitTurnTableGenerator.new.generate" -*-

module Bioshogi
  module Explain
    class TacticHitTurnTableGenerator
      def generate
        body = body_format(turns_hash.inspect)
        output_file.write(template % { body: body })
        puts "write: #{output_file}"
      end

      private

      def turns_hash
        hash = {}
        Explain::TacticInfo.all_elements.each do |e|
          print "."
          info = e.sample_kif_info
          found = info.xcontainer.hand_logs.each.with_index do |hand_log, i|
            if hand_log.skill_set.flat_map { |e| e.flat_map(&:key) }.include?(e.key)
              hash[e.key.to_s] = i.next
              break true
            end
          end
          if !found
            raise e.key
          end
        end
        puts
        hash
      end

      def output_file
        Pathname("#{__dir__}/tactic_hit_turn_table.rb").expand_path
      end

      def template
        o = []
        o << "# -*- frozen_string_literal: true -*-"
        o << "# #{__FILE__} から生成しているので編集するべからず"
        o << "module Bioshogi"
        o << "  module Explain"
        o << "    TacticHitTurnTable = {"
        o << "%{body}"
        o << "    }"
        o << "  end"
        o << "end"
        o.join("\n") + "\n"
      end

      def body_format(str)
        str = str.gsub(/{/, "")
        str = str.gsub(/}/, ",")
        str = str.gsub(/\s*,\s*/, ",\n")
        str = str.gsub(/^(?=")/, "  " * 3)
        str = str.gsub("=>", " => ")
        str = str.rstrip
      end
    end
  end
end
