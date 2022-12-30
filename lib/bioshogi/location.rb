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
module Bioshogi
  class Location
    include ApplicationMemoryRecord
    memory_record [
      { key: :black, name: "▲", pentagon_mark: "☗", equality_name: "先手", handicap_name: "下手", equality_yomiage: "先手", handicap_yomiage: "したて", flip_mark: "▼", varrow: " ", csa_sign: "+", angle: 0,   other_match_chars: ["☗"], to_sfen: "b", normalize_key: :itself, value_sign: +1, checkmate_yomiage: "せめかた",  },
      { key: :white, name: "△", pentagon_mark: "☖", equality_name: "後手", handicap_name: "上手", equality_yomiage: "後手", handicap_yomiage: "うわて", flip_mark: "▽", varrow: "v", csa_sign: "-", angle: 180, other_match_chars: ["☖"], to_sfen: "w", normalize_key: :flip,   value_sign: -1, checkmate_yomiage: "gyokugata", },
    ]

    class << self
      # lookup(-1).key     # => :white
      # lookup(:white).key # => :white
      def lookup(value)
        v = super

        if !v
          if value.kind_of?(Integer)
            v = lookup(value.modulo(count))
          end
        end

        if !v
          v = find { |e| e.match_target_values_set.include?(value) }
        end

        v
      end

      def polygon_chars_str
        @polygon_chars_str ||= flat_map { |e| [e.mark, e.flip_mark, e.pentagon_mark] }.join
      end

      # b w とかではなく sfen の駒の文字の大文字小文字で判断する
      # だから v をキーにしたテーブルにするのはやめたほうがいい
      def fetch_by_sfen_char(ch)
        if ch.match?(/[[:upper:]]/)
          self[:black]
        else
          self[:white]
        end
      end

      def call_names
        @call_names ||= flat_map(&:call_names)
      end
    end

    def call_names
      [equality_name, handicap_name]
    end

    def call_name(handicap)
      public_send(call_name_method_name(handicap))
    end

    def yomiage(handicap)
      if handicap
        handicap_yomiage
      else
        equality_yomiage
      end
    end

    def mark
      name
    end

    def black?
      key == :black
    end

    def white?
      key == :white
    end

    def which_value(a, b)
      black? ? a : b
    end

    def flip
      @flip ||= self.class.fetch(code.next.modulo(self.class.count))
    end

    alias next_location flip

    def match_target_values_set
      @match_target_values_set ||= [
        key,
        mark,
        flip_mark,
        pentagon_mark,
        other_match_chars,
        to_sfen,
        name,
        name.chars.first,
        code,
        varrow,
        csa_sign,
        equality_name,
        handicap_name,
      ].flatten.compact.to_set
    end

    # FIXME: とる
    # HTMLにするとき楽なように後手なら transform: rotate(180deg) を返す
    def style_transform
      if angle.nonzero?
        "transform: rotate(#{angle}deg)"
      end
    end

    private

    def call_name_method_name(handicap)
      if handicap
        :handicap_name
      else
        :equality_name
      end
    end
  end
end
