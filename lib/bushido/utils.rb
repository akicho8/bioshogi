# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-
#
# 汎用の便利メソッド集
#

module Bushido
  module Utils
    extend self

    def parse_arg(arg)
      # if arg.kind_of?(String)
        info = parse_string_arg(arg)
        # if info[:options] == "成"
        #   raise SyntaxError, "駒の配置するときは「○成」ではなく「成○」: #{arg.inspect}"
        # end
        info
      # else
      #   p arg
      # 
      #   # if true
      #   #   # FIXME: ここ使ってないわりにごちゃごちゃしているから消そう
      #   #   piece = arg[:piece]
      #   #   promoted = arg[:promoted]
      #   #   if piece.kind_of?(String)
      #   #     promoted, piece = Piece.parse!(piece)
      #   #   end
      #   #   arg.merge(:point => Point[arg[:point]], :piece => piece, :promoted => promoted)
      #   # else
      #   #   arg
      #   # end
      # end
    end

    def first_placements2(location)
      table = Utils.first_placements.collect{|arg|Utils.parse_arg(arg)}
      if Location[location].white?
        table.each{|info|info[:point] = info[:point].reverse}
      end
      table
    end

    def first_placements
      [
        "9七歩", "8七歩", "7七歩", "6七歩", "5七歩", "4七歩", "3七歩", "2七歩", "1七歩",
        "8八角", "2八飛",
        "9九香", "8九桂", "7九銀", "6九金", "5九玉", "4九金", "3九銀", "2九桂", "1九香",
      ]
    end

    private

    def parse_string_arg(str)
      md = str.match(/\A(?<point>..)(?<piece>#{Piece.names.join("|")})(?<options>.*)/)
      md or raise SyntaxError, "表記が間違っています : #{str.inspect}"
      if md[:options] == "成"
        raise SyntaxError, "駒の配置するときは「○成」ではなく「成○」: #{str.inspect}"
      end
      point = Point.parse(md[:point])
      promoted, piece = Piece.parse!(md[:piece])
      {:point => point, :piece => piece, :promoted => promoted, :options => md[:options]}
    end
  end
end
