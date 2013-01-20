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

    # mark_with_name # => "▲先手"
    def mark_with_name
      "#{mark}#{name}"
    end

    def black?
      key == :black
    end

    def white?
      key == :white
    end

    def values
      [key, mark, name]
    end

    def first_or_last
      _which(:first, :last)
    end

    def last_or_first
      _which(:last, :first)
    end

    def _which(a, b)
      black? ? a : b
    end

    @list ||= [
      new(:key => :black, :mark => "▲", :name => "先手", :varrow => " ", :zarrow => ""),
      new(:key => :white, :mark => "▽", :name => "後手", :varrow => "v", :zarrow => "↓"),
    ]

    # Location.parse(:black).name # => "先手"
    def self.parse(arg)
      if arg.kind_of? self
        return arg
      end
      @list.find{|e|e.values.include?(arg)} or raise SyntaxError, "#{arg.inspect}"
    end
  end
end
