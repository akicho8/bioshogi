# -*- coding: utf-8 -*-
#
# 先手・後手
#
module Bushido
  class Location
    def initialize(info)
      @info = info
    end

    [:key, :mark, :name, :varrow, :zarrow].each do |v|
      define_method(v){
        @info[v]
      }
    end

    # 「▲先手」みたいなのを返す
    # mark_with_name # => "▲先手"
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
      [key, mark, name]
    end

    # 先手ならaを後手ならbを返す
    def _which(a, b)
      black? ? a : b
    end

    @pool ||= [
      new(:key => :black, :mark => "▲", :name => "先手", :varrow => " ", :zarrow => ""),
      new(:key => :white, :mark => "▽", :name => "後手", :varrow => "v", :zarrow => "↓"),
    ]

    # 引数に対応する先手または後手の情報を返す
    #   Location.parse(:black).name # => "先手"
    def self.parse(arg)
      if arg.kind_of? self
        return arg
      end
      @pool.find{|e|e.match_target_values.include?(arg)} or raise SyntaxError, "#{arg.inspect}"
    end

    # 引数に対応する先手または後手の情報を返す
    #   Location[:black].name # => "先手"
    def self.[](*args)
      parse(*args)
    end
  end
end
