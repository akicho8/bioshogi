# frozen-string-literal: true

module Warabi
  module InputParser
    extend self

    def match!(str)
      md = str.to_s.match(regexp)
      unless md
        raise SyntaxDefact, "表記が間違っています : #{str.inspect}"
      end
      md
    end

    def scan(str)
      str.to_s.scan(regexp).collect(&:join)
    end

    def slice_one(str)
      scan(str.to_s).first
    end

    def regexp
      @regexp ||= Regexp.union(kif_or_ki2_regexp, csa_regexp, usi_regexp)
    end

    private

    def kif_or_ki2_regexp
      ki2_location = /(?<ki2_location>[#{Location.triangles_str}])/o
      kif_point = /(?<kif_point>#{Point.regexp})/o
      ki2_same = /(?<ki2_same>同)\p{blank}*/

      ki2_as_it_is = /(?<ki2_as_it_is>不成|生)/
      ki2_promote_trigger = /(?<ki2_promote_trigger>成)/
      kif_direct_trigger = /(?<kif_direct_trigger>[打合])/

      ki2_one_up = /(?<ki2_one_up>直)/
      ki2_left_right = /(?<ki2_left_right>[左右])/
      ki2_up_down = /(?<ki2_up_down>[上行引寄])/ # 行は上のalias

      /
        #{ki2_location}?
        (#{kif_point}#{ki2_same}|#{ki2_same}#{kif_point}|#{kif_point}|#{ki2_same}) # 12同 or 同12 or 12 or 同 に対応
        (?<kif_piece>#{Piece.all_names.join("|")})
        (#{ki2_one_up}|#{ki2_left_right}?#{ki2_up_down}?)?
        (#{ki2_as_it_is}|#{ki2_promote_trigger}|#{kif_direct_trigger})?
        (?<kif_point_from>\(\d{2}\))? # scan の結果を join したものがマッチした元の文字列と一致するように () も含める
      /ox
    end

    def csa_regexp
      csa_piece = Piece.flat_map { |e| [e.csa_basic_name, e.csa_promoted_name] }.compact.join("|")

      /
        (?<csa_sign>[+-])?
        (?<csa_from>[0-9]{2}) # 00 = 駒台
        (?<csa_to>[1-9]{2})
        (?<csa_piece>#{csa_piece})
      /ox
    end

    def usi_regexp
      usi_direct_piece = Piece.collect(&:sfen_char).compact.join
      usi_to = /[1-9][[:lower:]]/

      direct_part = /(?<usi_direct_piece>[#{usi_direct_piece}])(?<usi_direct_trigger>\*)(?<usi_to>#{usi_to})/o
      move_part = /(?<usi_from>#{usi_to})(?<usi_to>#{usi_to})(?<usi_promote_trigger>\+)?/o

      /((#{direct_part})|(#{move_part}))/o
    end
  end
end
