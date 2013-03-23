# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/shash_spec.rb" -*-
#
#  MiniSoldier.from_str("４二竜") # => {:point => Point["４二"], :piece => Piece["竜"], :promoted => true}
#
module Bushido
  class MiniSoldier < Hash
    # 人間が入力する *初期配置* の "４二竜" などをハッシュに分割する
    #   MiniSoldier.from_str("４二竜") # => {:point => Point["４二"], :piece => Piece["竜"], :promoted => true}
    def self.from_str(str)
      return str if MiniSoldier === str
      md = str.match(/\A(?<point>..)(?<piece>#{Piece.names.join("|")})\z/)
      md or raise SyntaxError, "表記が間違っています。'４二竜' や '42竜' のように入力してください : #{str.inspect}"
      Piece.promoted_fetch(md[:piece]).merge(:point => Point.parse(md[:point]))
    end

    # ハッシュにした駒を人間が入力する表記に戻す
    #   Utils.shash_to_s(MiniSoldier.from_str("４二竜")) # => "４二竜"
    def to_s
      "#{self[:point].name}#{self[:piece].some_name(self[:promoted])}"
    end
  end
end
