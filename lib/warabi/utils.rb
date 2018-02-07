# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/utils_spec.rb" -*-
# frozen-string-literal: true
#
# 汎用の便利メソッド集
#

require "active_support/core_ext/object/to_query"

module Warabi
  module Utils
    extend self

    # ki2形式に近い棋譜の羅列のパース
    # @example
    #   ki2_parse("▲４二銀△４二銀") # => [{location: :black, input: "４二銀"}, {location: :white, input: "４二銀"}]
    def ki2_parse(str)
      str = str.to_s
      str = str.gsub(/([#{Location.triangles_str}])/, ' \1')
      str = str.squish
      str.split.collect { |s|
        if s.match?(/\A[#{Location.triangles_str}]/)
          movs_split(s)
        else
          s
        end
      }.flatten
    end

    def movs_split(str)
      regexp = /([#{Location.triangles_str}])([^#{Location.triangles_str}\s]+)/
      Array.wrap(str).join(" ").scan(regexp).collect{|mark, input|
        {location: Location[mark], input: input}
      }
    end

    def initial_battlers_split(str)
      movs_split(str.gsub(/_+/, " "))
    end

    def mov_split_one(str)
      md = str.match(/(?<mark>[#{Location.triangles_str}])(?<input>.*)/)
      # md or raise(ArgumentError)
      {location: Location[md[:mark]], input: md[:input]}
    end

    # # 後手のみ先手用になっている初期駒配置を反転させる
    # def board_point_realize(params)
    #   params[:both_board_info].inject({}) do |a, (key, value)|
    #     a.merge(key => value.collect { |s| s.merge(point: s[:point].reverse_if_white(params[:location])) })
    #   end
    # end

    # soldiers を location 側の配置に変更したのを返す
    def board_point_realize2(soldiers, location)
      soldiers.collect { |e| e.merge(point: e[:point].reverse_if_white(location)) }
    end

  end
end
