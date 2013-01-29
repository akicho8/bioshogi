# -*- coding: utf-8 -*-
#
# 盤面
#   board = Board.new
#   board["５五"] # => nil
#
module Bushido
  class Board
    attr_reader :surface

    def initialize
      @surface = {}
    end

    # 指定座標に駒を置く
    #   board.put_on_at("５五", soldier)
    def put_on_at(point, soldier)
      soldier.point = point
      piece_alredy_exist_validation(point)
      soldier.double_pawn_validation(self, point)
      @surface[point.to_xy] = soldier
      if soldier.moveable_points(:board_object_collision_skip => true, :point => point).empty?
        raise NotPutInPlaceNotBeMoved, "#{soldier.formality_name}を#{point.name}に置いてもそれ以上動かせないので反則になります"
      end
    end

    # fetchのエイリアス
    #   board["５五"] # => nil
    def [](point)
      fetch(point)
    end

    # 盤面の指定座標の取得
    #   board.fetch["５五"] # => nil
    def fetch(point)
      @surface[Point.parse(point).to_xy]
    end

    # 指定座標にある駒をを広い上げる
    def pick_up!(point)
      soldier = @surface.delete(point.to_xy)
      soldier or raise NotFoundOnBoard, "#{point.name}の位置には何もありません"
      soldier.point = nil
      soldier
    end

    # 盤面表示
    #   to_s
    #   to_s(:debug)
    #   to_s(:kakiki)
    def to_s(format = :default)
      send("to_s_#{format}")
    end

    # 空いている場所のリスト
    def blank_points
      Point.all_points.find_all{|point|!fetch(point)}
    end

    private

    # 盤面の文字列化
    def to_s_default
      to_s(:kakiki)
    end

    # 盤面の文字列化(開発用なので好きなフォーマットでいい)
    def to_s_debug
      rows = Position::Vpos.units.size.times.collect{|y|
        Position::Hpos.units.size.times.collect{|x|
          @surface[[x, y]]
        }
      }
      rows = rows.zip(Position::Vpos.units).collect{|e, u|e + [u]}
      RainTable::TableFormatter.format(Position::Hpos.units + [""], rows, :header => true)
    end

    # 盤上の指定座標にすでに物があるならエラーとする
    def piece_alredy_exist_validation(point)
      if fetch(point)
        raise PieceAlredyExist, "#{point.name}にはすでに何かがあります"
      end
    end
  end
end
