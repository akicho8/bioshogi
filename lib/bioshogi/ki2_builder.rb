# frozen-string-literal: true

module Bioshogi
  class Ki2Builder
    include Builder

    def self.default_params
      super.merge({
          :column_count        => 10,
          :fixed_width => nil,
          :same_suffix => "　",
          :header_skip => false,
          :footer_skip => false,
        })
    end

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_ki2
      @parser.mediator_run_once

      out = []
      if @parser.header.present? && !@params[:header_skip]
        out << @parser.header_part_string
        out << "\n"
      end

      if @params[:fixed_width]
        # 固定幅で整列(値が小さいと揃わない場合がある)
        out << @parser.mediator.hand_logs.group_by.with_index {|_, i| i / @params[:column_count] }.values.collect { |v|
          v.collect { |e|
            s = e.to_ki2(with_location: true, same_suffix: @params[:same_suffix])
            @parser.mb_ljust(s, @params[:fixed_width])
          }.join.strip + "\n"
        }.join
      else
        # 自動整列(かならず揃う)
        list = @parser.mediator.hand_logs.collect do |e|
          e.to_ki2(with_location: true, same_suffix: @params[:same_suffix])
        end

        list2 = list.in_groups_of(@params[:column_count])
        column_widths = list2.transpose.collect do |e|
          e.collect { |e| e.to_s.toeuc.bytesize }.max
        end

        list2 = list2.collect do |a|
          a.collect.with_index do |e, i|
            @parser.mb_ljust(e.to_s, column_widths[i])
          end
        end
        out << list2.collect { |e| e.join(" ").strip + "\n" }.join
      end

      unless @params[:footer_skip]
        out << @parser.judgment_message + "\n"
        out << @parser.error_message_part
      end

      out.join
    end
  end
end
