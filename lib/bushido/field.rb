# -*- coding: utf-8 -*-
module Bushido
  class Field
    attr_accessor :matrix

    def initialize
      @matrix = {}
    end

    def put_on_at(point, soldier)
      if fetch(point)
        raise PieceAlredyExist, "#{point.name}にはすでに何かがあります"
      end

      point.y.class.units.each{|y|
        if obj = fetch(Point[[point.x, y]])
          if obj.player == soldier.player &&
              soldier.piece.kind_of?(Piece::Pawn) && !soldier.promoted &&
              obj.piece.kind_of?(Piece::Pawn) && !obj.promoted
            raise DoublePawn, "二歩です。#{obj.name}があるため#{point.name}に#{soldier}は打てません。"
          end
        end
      }

      @matrix[point.to_xy] = soldier

      # FIXME: 無限ループ
      if soldier.moveable_points(:ignore_the_other_pieces_on_the_board => true, :point => point).empty?
        raise NotPutInPlaceNotBeMoved, "#{soldier.name}を#{point.name}に置いてもそれ以上動かせないので反則になります"
      end
    end

    def [](point)
      fetch(point)
    end

    def fetch(point)
      @matrix[Point[point].to_xy]
    end

    def pick_up!(point)
      @matrix.delete(point.to_xy) or raise NotFoundOnField, "#{point.name}の位置には何もありません"
    end

    def to_s
      rows = Position::Vpos.units.size.times.collect{|y|
        Position::Hpos.units.size.times.collect{|x|
          @matrix[[x, y]]
        }
      }
      rows = rows.zip(Position::Vpos.units).collect{|e, u|e + [u]}
      RainTable::TableFormatter.format(Position::Hpos.units + [""], rows, :header => true)
    end
  end
end
