module Warabi
  module Parser
    concern :Ki2Serializer do
      def to_ki2(**options)
        options = {
          cols: 10,
          # length: 11,
          same_suffix: "　",
          header_skip: false,
        }.merge(options)

        mediator_run

        out = []
        if header.present? && !options[:header_skip]
          out << header_part_string
          out << "\n"
        end

        if false
          out << mediator.hand_logs.group_by.with_index{|_, i| i / options[:cols] }.values.collect { |v|
            v.collect { |e|
              s = e.to_s_ki2(with_mark: true, same_suffix: options[:same_suffix])
              mb_ljust(s, options[:length])
            }.join.strip + "\n"
          }.join
        else
          list = mediator.hand_logs.collect do |e|
            e.to_s_ki2(with_mark: true, same_suffix: options[:same_suffix])
          end

          list2 = list.in_groups_of(options[:cols])
          column_widths = list2.transpose.collect do |e|
            e.collect { |e| e.to_s.toeuc.bytesize }.max
          end

          list2 = list2.collect do |a|
            a.collect.with_index do |e, i|
              mb_ljust(e.to_s, column_widths[i])
            end
          end
          out << list2.collect { |e| e.join(" ").strip + "\n" }.join
        end

        out << judgment_message + "\n"
        out << error_message_part

        out.join
      end
    end
  end
end
