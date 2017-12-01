# frozen-string-literal: true
#
# 上下のみを表わす
#
# - 先手後手というのは平手の場合だけの名称
# - 駒落ちなら、まず名称が上手下手に代わり、もともと後手と呼ばれていた上側が先に指す
# - 先手というのが「先に指す」という意味で使われるなら「先手」は位置を特定できない。駒落ちなら△で、平手なら▲になる。
# - だから上下の位置を表わすのに先手後手の名前を使うのはまちがい
# - 上下は△▲だけに対応する
#
module Bushido
  class Location
    include ApplicationMemoryRecord
    memory_record [
      {key: :black, name: "▲", hirate_name: "先手", komaochi_name: "下手", reverse_mark: "▼", varrow: " ", csa_sign: "+", angle: 0,   other_match_chars: ["☗", "b"], },
      {key: :white, name: "△", hirate_name: "後手", komaochi_name: "上手", reverse_mark: "▽", varrow: "v", csa_sign: "-", angle: 180, other_match_chars: ["☖", "w"], },
    ]

    alias index code
    alias position code

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

        # -1 など
        unless v
          if value.kind_of?(Integer)
            v = lookup(value.modulo(count))
          end
        end

        # "☗" など
        unless v
          v = find { |e| e.match_target_values_set.include?(value) }
        end

        v
      end

      def fetch(value)
        begin
          super
        rescue
          raise LocationNotFound, value.inspect
        end
      end

      # 簡潔に書きたいとき用
      def b; self[:black]; end
      def w; self[:white]; end

      # "▲▼△△" を返す
      def triangles_str
        @triangles_str ||= collect { |e| [e.mark, e.reverse_mark] }.join
      end
    end

    # 平手と駒落ちの呼名両方
    def call_names
      [hirate_name, komaochi_name]
    end

    def call_name(komaochi)
      send(call_name_key(komaochi))
    end

    # # 「▲先手」みたいなのを返す
    # #   mark_with_name # => "▲先手"
    # def mark_with_name
    #   name
    #   # "#{mark}#{name}"
    # end

    def mark
      name
    end

    # ▲？
    def black?
      key == :black
    end

    # △？
    def white?
      key == :white
    end

    # 先手ならaを後手ならbを返す
    def which_val(a, b)
      black? ? a : b
    end

    # 反対を返す
    def reverse
      @reverse ||= self.class.fetch(index.next.modulo(self.class.count))
    end

    # # オブジェクトIDが異なってもキーが同じなら一致(Marshal関連で復活させたとき不一致になるため追加)
    # def ==(other)
    #   key == other.key
    # end

    alias next_location reverse

    # lookup で引ける値のセットを返す
    # 自分のクラスメソッド内で使っているだけなので protected にしたいけど ruby はできない
    def match_target_values_set
      @match_target_values_set ||= [
        key,
        mark,
        reverse_mark,
        other_match_chars,
        name,
        name.chars.first,
        index,
        varrow,
        csa_sign,
        hirate_name,
        komaochi_name,
      ].flatten.to_set
    end

    # HTMLにするとき楽なように後手なら transform: rotate(180deg) を返す
    def style_transform
      if angle.nonzero?
        "transform: rotate(#{angle}deg)"
      end
    end

    private

    def call_name_key(komaochi)
      if komaochi
        :komaochi_name
      else
        :hirate_name
      end
    end

    # each do |e|
    #   e.match_target_values_set
    #   e.reverse
    #   e.freeze
    # end
  end

  L = Location
end
