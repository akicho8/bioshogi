# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/shash_spec.rb" -*-
#
#  MiniSoldier.from_str("４二竜") # => {point: Point["４二"], piece: Piece["竜"], promoted: true}
#
module Bushido
  class MiniSoldier < Hash
    # 人間が入力する *初期配置* の "４二竜" などをハッシュに分割する
    #   MiniSoldier.from_str("４二竜") # => {point: Point["４二"], piece: Piece["竜"], promoted: true}
    def self.from_str(str)
      return str if MiniSoldier === str
      md = str.match(/\A(?<point>..)(?<piece>#{Piece.names.join("|")})\z/)
      md or raise SyntaxError, "表記が間違っている。'４二竜' や '42竜' のように入力してください : #{str.inspect}"
      Piece.promoted_fetch(md[:piece]).merge(point: Point.parse(md[:point]))
    end

    # 「１一香成」ではなく「１一杏」を返す
    # 指し手を返すには to_hand を使うこと
    def to_s
      [self[:point].name, self[:piece].some_name(self[:promoted])].join
    end

    def some_name
      self[:piece].some_name(self[:promoted])
    end

    # 現状の状態から成れるか？
    def sarani_nareru?(location)
      !self[:promoted] && self[:piece].promotable? && self[:point].promotable?(location)
    end

    def point
      self[:point]
    end

    # def inspect
    #   s = collect{|k, v|"#{k}:#{v}"}.join(" ")
    #   "<MiniSoldier #{s}>"
    # end
  end

  # どこからどこへ 成るかどうかの情報を含めたもの
  # origin_soldier と promoted_trigger が必要。どちらか一方だけで to_hand は作れる。
  class SoldierMove < MiniSoldier
    def to_hand
      [self[:point].name, self[:origin_soldier].some_name, (self[:promoted_trigger] ? "成" : ""), "(", self[:origin_soldier].point.number_format, ")"].join
      # [self[:point].name, self[:origin_soldier].piece_current_name, (self[:promoted_trigger] ? "成" : ""), "(", self[:origin_soldier].point.number_format, ")"].join
    end
  end

  # 打
  class PieceStake < MiniSoldier
    def to_hand
      [self[:point].name, self[:piece].name, "打"].join
    end
  end
end
