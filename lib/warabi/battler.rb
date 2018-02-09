# frozen-string-literal: true
module Warabi
  #
  # 盤上の駒
  #   player を直接もつのではなく :white, :black を持てばいいような気もしている
  #   引数もバラバラではなく文字列だけで入力してインスタンスを生成
  #
  class Battler < Soldier
    attr_accessor :player

    def attributes
      super.merge(player: player)
    end

    # 移動可能な座標を取得
    def movable_infos
      Movabler.movable_infos(player, to_soldier)
    end

    # 盤面情報と比較するならこれを使う
    def to_soldier
      Soldier.create(piece: piece, promoted: promoted, point: point, location: location)
    end

    def to_h
      to_soldier.to_h
    end
  end
end
