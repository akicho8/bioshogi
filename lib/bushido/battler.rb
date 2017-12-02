# frozen-string-literal: true
module Bushido
  #
  # 盤上の駒
  #   player を直接もつのではなく :white, :black を持てばいいような気もしている
  #   引数もバラバラではなく文字列だけで入力してインスタンスを生成
  #
  class Battler
    attr_accessor :player, :piece, :promoted, :point, :location

    def initialize(attrs)
      attrs.assert_valid_keys(:player, :piece, :promoted, :point, :location)

      if attrs[:location]
        if attrs[:location] != attrs[:player].location
          raise MustNotHappen
        end
      end

      @player = attrs[:player]
      @piece = attrs[:piece]
      @location = @player.location

      self.promoted = attrs[:promoted]

      if attrs[:point]
        @point = Point.parse(attrs[:point])
      end

      unless @player && @piece
        raise MustNotHappen, attrs.inspect
      end
    end

    # 成り/不成状態の設定
    def promoted=(v)
      @piece.assert_promotable(v)
      @promoted = !!v
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
    def movable_infos
      Movabler.movable_infos(@player, to_soldier)
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
    def to_soldier
      Soldier[piece: @piece, promoted: @promoted, point: @point, location: @player.location]
    end

    def to_h
      to_soldier.to_h
    end

    # この盤上の駒を消す
    def abone
      @player.board.abone_on(@point)
      @player.battlers.delete(self)
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
        @piece.any_name(@promoted)
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
      def to_kif
        "#{@player.location.varrow}#{piece_current_name}"
      end
    end
  end
end
