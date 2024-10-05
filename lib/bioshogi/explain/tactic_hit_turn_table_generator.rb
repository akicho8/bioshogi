module Bioshogi
  module Explain
    class TacticHitTurnTableGenerator
      def initialize(options = {})
        @options = {
          verbose: true,
        }.merge(options)
      end

      def call
        body = body_format(to_h.inspect)
        output_file.write(template % { body: body })
        if @options[:verbose]
          puts "write: #{output_file}"
        end
      end

      def to_h
        list = Explain::TacticInfo.all_elements.collect do |e|
          turn = nil
          e.sample_kif_info.formatter.container.hand_logs.each.with_index do |hand_log, i|
            if hand_log.skill_set.flat_map { |e| e.flat_map(&:key) }.include?(e.key)
              turn = i.next
              break
            end
          end
          [e, turn]
        end

        list.sort_by { |e, turn| [turn || 0, e.name] }.collect { |e, turn| [e.name, turn] }.to_h
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
        str = str.gsub(/ "/, ':"')
        str = str.rstrip
      end
    end
  end
end
