# -*- coding: utf-8 -*-
module Bushido
  class Field
    attr_accessor :matrix

    def initialize
      @matrix = {}
    end

    def put_on_at(point, soldier)
      if fetch(point)
        raise PieceAlredyExist
      end

      @matrix[point.to_xy] = soldier
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
