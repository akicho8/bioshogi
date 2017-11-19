#
# 先手・後手
#
module Bushido
  class Location
    include MemoryRecord
    memory_record [
      {key: :black, name: "先手", mark: "▲", reverse_mark: "▼", other_marks: ["b", "^"], varrow: " ", angle: 0,   csa_sign: "+"},
      {key: :white, name: "後手", mark: "▽", reverse_mark: "△", other_marks: ["w"],      varrow: "v", angle: 180, csa_sign: "-"},
    ]

    alias index code

    class << self
      # 引数に対応する先手または後手の情報を返す
      #
      #   Location[:black].name   # => "先手"
      #   Location["▲"].name     # => "先手"
      #   Location["先手"].name   # => "先手"
      #   Location[0].name        # => "先手"
      #   Location[1].name        # => "後手"
      #   Location[2]             # => SyntaxDefact
      #   Location["1手目"].name  # => "先手"
      #   Location["2手目"].name  # => "後手"
      #   Location["3手目"].name  # => "先手"
      #   Location["+"].name      # => "先手"
      #   Location["-"].name      # => "後手"
      #
      def lookup(value)
        v = super
        unless v
          v = find { |e| e.match_target_values.include?(value) }
        end
        unless v
          if value.kind_of?(Integer)
            v = lookup(value.modulo(count))
          end
        end
        unless v
          if value.kind_of?(String) && md = value.match(/(?<turn_number>\d+)/)
            index = md[:turn_number].to_i.pred
            v = lookup(index.modulo(count))
          end
        end
        v or raise TurnNumberSyntaxError, value.inspect
      end

      # 簡潔に書きたいとき用
      def b; self[:black]; end
      def w; self[:white]; end

      # "▲▼▽△" を返す
      def triangles
        @triangles ||= collect { |e| [e.mark, e.reverse_mark] }.join
      end
    end

    # 「▲先手」みたいなのを返す
    #   mark_with_name # => "▲先手"
    def mark_with_name
      "#{mark}#{name}"
    end

    # 先手か？
    def black?
      key == :black
    end

    # 後手か？
    def white?
      key == :white
    end

    # 属性っぽい値を全部返す
    def match_target_values
      [key, mark, reverse_mark, other_marks, name, name.chars.first, index, varrow, csa_sign].flatten
    end

    # 先手ならaを後手ならbを返す
    def where_value(a, b)
      black? ? a : b
    end

    # 反対を返す
    def reverse
      self.class.fetch(index.next.modulo(self.class.count))
    end

    # # オブジェクトIDが異なってもキーが同じなら一致(Marshal関連で復活させたとき不一致になるため追加)
    # def ==(other)
    #   key == other.key
    # end

    alias next_location reverse

    # HTMLにするとき楽なように後手なら transform: rotate(180deg) を返す
    def style_transform
      if angle.nonzero?
        "transform: rotate(#{angle}deg)"
      end
    end
  end

  L = Location
end
