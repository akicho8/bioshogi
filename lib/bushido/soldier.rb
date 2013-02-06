# -*- coding: utf-8 -*-
#
# 盤上の駒
#
module Bushido
  class Soldier
    attr_accessor :player, :piece, :promoted, :point

    def initialize(player, piece, promoted = false)
      @player = player
      @piece = piece
      self.promoted = promoted
    end

    # 成り/不成状態の設定
    def promoted=(promoted)
      if !@piece.promotable? && promoted
        raise NotPromotable, "成れない駒で成ろうとしています : #{piece.inspect}"
      end
      @promoted = promoted
    end

    def to_s(format = :default)
      send("to_s_#{format}")
    end

    def to_s_default
      "#{piece_current_name}#{@player.location.zarrow}"
    end

    def inspect
      "<#{self.class.name}:#{object_id} @player=#{@player} @piece=#{@piece} #{formality_name}>"
    end

    [:promoted].each{|key|
      if public_method_defined?(key)
        define_method("#{key}?"){public_send(key)}
      end
    }

    # 駒の名前
    def piece_current_name
      @piece.some_name(@promoted)
    end

    # 正式な棋譜の表記で返す
    #  Player.basic_test(:init => "５五と").board["５五"].formality_name # => "▲5五と"
    def formality_name
      "#{@player.location.mark}#{formality_name2}"
    end

    # 正式な棋譜の表記で返す
    #  Player.basic_test(:init => "５五と").board["５五"].formality_name2 # => "5五と"
    def formality_name2
      "#{point ? point.name : '(どこにも置いてない)'}#{self}"
    end

    # 自分が保持している座標ではなく盤面から自分を探す (デバッグ用)
    def read_point
      if xy = @player.board.surface.invert[self]
        Point.parse(xy)
      end
    end

    # 移動可能な座標を取得
    def moveable_points2(options = {})
      Movabler.moveable_points(@player, @point, @piece, @promoted, options)
    end
  end
end
