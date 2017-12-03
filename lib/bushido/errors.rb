# frozen-string-literal: true

module Bushido
  class BushidoError < StandardError
  end

  class MustNotHappen < BushidoError
  end

  class UnconfirmedObject < BushidoError
  end

  class MovableBattlerNotFound < BushidoError
  end

  class AmbiguousFormatError < BushidoError
  end

  class BattlerEmpty < BushidoError
  end

  class PieceNotFound < BushidoError
  end

  class HoldPieceNotFound < BushidoError
  end

  class PieceAlredyExist < BushidoError
  end

  class AlredyPromoted < BushidoError
  end

  class BeforePointNotFound < BushidoError
  end

  class FileFormatError < BushidoError
  end

  class KeyNotFound < BushidoError
  end

  # 構文エラー
  class SyntaxDefact < BushidoError
  end

  class IllegibleFormat < SyntaxDefact
  end

  class RuleError < SyntaxDefact
    def initialize(message)
      super "【反則】#{message}"
    end
  end

  # パース時にオプションで例外を抑制できる系の反則
  class TypicalError < RuleError
  end

  class HistroyStackEmpty < SyntaxDefact
  end

  class SamePointDifferent < SyntaxDefact
  end

  # 盤面定義のエラー
  class BoardIsBlackOnly < SyntaxDefact
  end

  # 構文エラーから発生する継続が難しいエラー
  class PositionSyntaxError < SyntaxDefact
  end

  class PointSyntaxError < SyntaxDefact
  end

  # 手番の表記がおかしい
  class LocationNotFound < SyntaxDefact
  end

  # 別に問題ないけど将棋のルール上エラーとするもの

  class DeadPieceRuleError < RuleError
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

  class SamePlayerBattlerOverwrideError < RuleError
  end

  class AitenoKomaUgokashitaError < RuleError
  end

  # 例外を抑制できる系の反則

  # 二歩
  class DoublePawnError < TypicalError
  end

  # 手番が異なる
  class DifferentTurnError < TypicalError
  end
end
