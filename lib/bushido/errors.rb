module Bushido
  class BushidoError < StandardError
  end

  class MustNotHappen < BushidoError
  end

  class UnconfirmedObject < BushidoError
  end

  class MovableSoldierNotFound < BushidoError
    def initialize(runner)
      @runner = runner
    end

    def message
      "「#{@runner.point.name}」に移動できる「#{@runner.piece.name}」がありません。入力した「#{@runner.source.inspect}」が間違っているのかもしれません\n#{@runner.player.mediator}"
    end
  end

  class AmbiguousFormatError < BushidoError
  end

  class SoldierEmpty < BushidoError
  end

  class PieceNotFound < BushidoError
  end

  class PieceAlredyExist < BushidoError
  end

  class AlredyPromoted < BushidoError
  end

  class NotPutInPlaceNotBeMoved < BushidoError
    def initialize(player, *args)
      @player = player
      super(*args)
    end

    def message
      "#{super}\n#{@player.board}"
    end
  end

  class BeforePointNotFound < BushidoError
  end

  class FileFormatError < BushidoError
  end

  # 構文エラー
  class SyntaxError < BushidoError
  end

  class IllegibleFormat < SyntaxError
  end

  class RuleError < SyntaxError
  end

  class HistroyStackEmpty < SyntaxError
  end

  class SamePointDiff < SyntaxError
  end

  # 盤面定義のエラー
  class BoardKeyNotFound < SyntaxError
  end

  class BoardIsBlackOnly < SyntaxError
  end

  # 構文エラーから発生する継続が難しいエラー
  class PositionSyntaxError < SyntaxError
  end

  class PointSyntaxError < SyntaxError
  end

  # 別に問題ないけど将棋のルール上エラーとするもの
  class DoublePawn < RuleError
  end

  class NoPromotablePiece < RuleError
  end

  class NotFoundOnBoard < RuleError
  end

  class NotPromotable < RuleError
  end

  class PromotedPiecePutOnError < RuleError
  end

  class PromotedPieceToNormalPiece < RuleError
  end

  class SamePlayerSoldierOverwrideError < RuleError
  end
end
