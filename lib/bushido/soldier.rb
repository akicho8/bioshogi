# -*- coding: utf-8 -*-
#
# 盤上の駒
#   player を直接もつのではなく :white, :black を持てばいいような気もしている
#   引数もバラバラではなく文字列だけで入力してインスタンスを生成
#
module Bushido
  class Soldier
    attr_accessor :player, :piece, :promoted, :point

    def initialize(attrs)
      attrs.assert_valid_keys(:player, :piece, :promoted, :point)
      @player = attrs[:player]
      @piece = attrs[:piece]
      self.promoted = !!attrs[:promoted]
      if attrs[:point]
        @point = Point.parse(attrs[:point])
      end
      unless @player && @piece
        raise ArgumentError, attrs.inspect
      end
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
      "#{@player.location.varrow}#{piece_current_name}"
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
    #  Player.basic_test(init: "５五と").board["５五"].formality_name # => "▲5五と"
    def formality_name
      "#{@player.location.mark}#{formality_name2}"
    end

    alias name formality_name

    # 正式な棋譜の表記で返す
    #  Player.basic_test(init: "５五と").board["５五"].formality_name2 # => "5五と"
    def formality_name2
      "#{point ? point.name : '(どこにも置いてない)'}#{piece_current_name}"
    end

    # 自分が保持している座標ではなく盤面から自分を探す (デバッグ用)
    def read_point
      if xy = @player.board.surface.invert[self]
        Point.parse(xy)
      end
    end

    # 移動可能な座標を取得
    def movable_infos(options = {})
      Movabler.movable_infos(@player, to_mini_soldier, options)
    end

    # def self.from_attrs(attrs)
    #   new(attrs)
    # end
    #
    # # シリアライズ用
    # def to_attrs
    #   {player: (@player ? @player.location.key : nil) point: @point.name, piece: @piece.sym_name, promoted: @promoted}
    # end

    def to_mini_soldier
      MiniSoldier[point: @point, piece: @piece, promoted: @promoted]
    end

    def to_h
      to_mini_soldier
    end

    # この盤上の駒を消す
    def abone
      @player.board.__abone_cell(@point)
      @player.soldiers.delete(self)
      @point = nil
      self
    end
  end
end
