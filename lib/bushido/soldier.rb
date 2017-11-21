#
# 盤上の駒
#   player を直接もつのではなく :white, :black を持てばいいような気もしている
#   引数もバラバラではなく文字列だけで入力してインスタンスを生成
#
module Bushido
  class Soldier
    attr_accessor :player, :piece, :promoted, :point

    def initialize(attrs)
      # attrs = attrs.except(:location) # 互換性のため暫定的に。FIXME: location も持たせたらいいんじゃね？

      attrs.assert_valid_keys(:player, :piece, :promoted, :point, :location)

      @player = attrs[:player]
      @piece = attrs[:piece]

      self.promoted = attrs[:promoted]

      if attrs[:point]
        @point = Point.parse(attrs[:point])
      end

      unless @player && @piece
        raise ArgumentError, attrs.inspect
      end
    end

    # 成り/不成状態の設定
    def promoted=(promoted)
      promoted = !!promoted
      if !@piece.promotable? && promoted
        raise NotPromotable, "成れない駒で成ろうとしています : #{piece.inspect}"
      end
      @promoted = promoted
    end

    def promoted?
      !!@promoted
    end

    # # 自分が保持している座標ではなく盤面から自分を探す (デバッグ用)
    # def read_point
    #   if xy = @player.board.surface.invert[self]
    #     Point.parse(xy)
    #   end
    # end

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
    #   {player: (@player ? @player.location.key : nil) point: @point.name, piece: @piece.key, promoted: @promoted}
    # end

    # 盤面情報と比較するならこれを使う
    def to_mini_soldier
      MiniSoldier[piece: @piece, promoted: @promoted, point: @point, location: @player.location]
    end

    def to_h
      to_mini_soldier.to_h
    end

    # この盤上の駒を消す
    def abone
      @player.board.__abone_cell(@point)
      @player.soldiers.delete(self)
      @point = nil
      self
    end

    concerning :NameMethods do
      def name
        mark_with_formal_name
      end

      def to_s
        mark_with_formal_name
      end

      def to_csa
        "#{@player.location.csa_sign}#{@piece.csa_some_name(@promoted)}"
      end

      def inspect
        "<#{self.class.name}:#{object_id} @player=#{@player} @piece=#{@piece} #{mark_with_formal_name}>"
      end

      # 駒の名前
      def piece_current_name
        @piece.some_name(@promoted)
      end

      # 正式な棋譜の表記で返す
      #  Player.basic_test(init: "５五と").board["５五"].mark_with_formal_name # => "▲５五と"
      def mark_with_formal_name
        "#{@player.location.mark}#{formal_name}"
      end

      # 正式な棋譜の表記で返す
      #  Player.basic_test(init: "５五と").board["５五"].formal_name # => "５五と"
      def formal_name
        "#{point ? point.name : '(どこにも置いてない)'}#{piece_current_name}"
      end

      # 柿木盤面用
      def to_s_kakiki
        "#{@player.location.varrow}#{piece_current_name}"
      end
    end
  end
end
