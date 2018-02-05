# frozen-string-literal: true

module Warabi
  class WarabiError < StandardError
  end

  class MustNotHappen < WarabiError
  end

  class UnconfirmedObject < WarabiError
  end

  class MovableBattlerNotFound < WarabiError
  end

  class AmbiguousFormatError < WarabiError
  end

  class BattlerEmpty < WarabiError
  end

  class PieceNotFound < WarabiError
  end

  class HoldPieceNotFound < WarabiError
  end

  class PieceAlredyExist < WarabiError
  end

  class AlredyPromoted < WarabiError
  end

  class BeforePointNotFound < WarabiError
  end

  class FileFormatError < WarabiError
  end

  class KeyNotFound < WarabiError
  end

  # 構文エラー
  class SyntaxDefact < WarabiError
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
