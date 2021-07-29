module Bioshogi
  module Formatter
    concern :Ki2FormatMethods do
      def to_ki2(options = {})
        options = {
          cols: 10,
          fixed_width: nil,
          same_suffix: "　",
          header_skip: false,
        }.merge(options)

        mediator_run

        out = []
        if header.present? && !options[:header_skip]
          out << header_part_string
          out << "\n"
        end

        if options[:fixed_width]
          # 固定幅で整列(値が小さいと揃わない場合がある)
          out << mediator.hand_logs.group_by.with_index {|_, i| i / options[:cols] }.values.collect { |v|
            v.collect { |e|
              s = e.to_ki2(with_location: true, same_suffix: options[:same_suffix])
              mb_ljust(s, options[:fixed_width])
            }.join.strip + "\n"
          }.join
        else
          # 自動整列(かならず揃う)
          list = mediator.hand_logs.collect do |e|
            e.to_ki2(with_location: true, same_suffix: options[:same_suffix])
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
