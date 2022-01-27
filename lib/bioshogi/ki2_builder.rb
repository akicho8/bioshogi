# frozen-string-literal: true

module Bioshogi
  class Ki2Builder
    include Builder
    include KakinokiBuilder

    class << self
      def default_params
        super.merge({
            :column_style => :auto, # auto: 自動的に揃える, fixed: 指定の幅(column_width)で揃える
            :column_max   => 8,     # 最大N列
            :column_width => 12,    # column_style が fixed のときのカラム幅
            :same_suffix  => "　",  # "同角" みたいなときに "同" と "角" の間に入れる文字列
          })
      end
    end

    private

    def body_hands
      send "#{@params[:column_style]}_width_body_hands"
    end

    # 固定幅で整列
    # 値が小さいと揃わない場合がある
    def fixed_width_body_hands
      @parser.mediator.hand_logs.group_by.with_index {|_, i| i / @params[:column_max] }.values.collect { |v|
        v.collect { |e|
          s = e.to_ki2(with_location: true, same_suffix: @params[:same_suffix])
          mb_ljust(s, @params[:column_width])
        }.join.strip + "\n"
      }.join
    end

    # 自動整列
    # かならず揃う
    def auto_width_body_hands
      list = @parser.mediator.hand_logs.collect do |e|
        e.to_ki2(with_location: true, same_suffix: @params[:same_suffix])
      end

      list2 = list.in_groups_of(@params[:column_max])
      column_widths = list2.transpose.collect do |e|
        e.collect { |e| e.to_s.toeuc.bytesize }.max
      end

      list2 = list2.collect do |a|
        a.collect.with_index do |e, i|
          mb_ljust(e.to_s, column_widths[i])
        end
      end
      list2.collect { |e| e.join(" ").strip + "\n" }.join
    end
  end
end
