# -*- coding: utf-8 -*-
#
# 先手・後手
#
module Bushido
  class Location
    def initialize(info)
      @info = info
    end

    [:key, :mark, :other_marks, :name, :varrow, :zarrow, :index].each do |v|
      define_method(v) do
        @info[v]
      end
    end

    # 「▲先手」みたいなのを返す
    #   mark_with_name # => "▲先手"
    def mark_with_name
      "#{mark}#{name}"
    end

    # 先手か？
    def black?
      key == :black
    end

    # 後手か？
    def white?
      key == :white
    end

    # 属性っぽい値を全部返す
    def match_target_values
      [key, mark, other_marks, name, name.chars.first, index].flatten
    end

    # 先手ならaを後手ならbを返す
    def _which(a, b)
      black? ? a : b
    end

    @pool ||= [
      new(:key => :black, :mark => "▲", :other_marks => ["b", "▼"], :name => "先手", :varrow => " ", :zarrow => "",   :index => 0),
      new(:key => :white, :mark => "▽", :other_marks => ["w", "△"], :name => "後手", :varrow => "v", :zarrow => "↓", :index => 1),
    ]

    class << self
      # 引数に対応する先手または後手の情報を返す
      #   Location.parse(:black).name   # => "先手"
      #   Location.parse("▲").name     # => "先手"
      #   Location.parse("先手").name   # => "先手"
      #   Location.parse(0).name        # => "先手"
      #   Location.parse(1).name        # => "後手"
      #   Location.parse(2)             # => SyntaxError
      #   Location.parse("1手目").name  # => "先手"
      #   Location.parse("2手目").name  # => "後手"
      #   Location.parse("3手目").name  # => "先手"
      def parse(arg)
        if self === arg
          return arg
        end
        r = find{|e|e.match_target_values.include?(arg)}
        unless r
          if String === arg && md = arg.match(/(?<location_index>\d+)手目/)
            r = parse((md[:location_index].to_i - 1).modulo(each.count))
          end
        end
        r or raise SyntaxError, "#{arg.inspect}"
      end

      # 引数に対応する先手または後手の情報を返す
      #   Location[:black].name # => "先手"
      def [](*args)
        parse(*args)
      end

      include Enumerable

      def each(&block)
        @pool.each(&block)
      end
    end
  end
end
