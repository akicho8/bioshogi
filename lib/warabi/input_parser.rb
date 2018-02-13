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
      triangle = /(?<triangle>[#{Location.triangles_str}])/o
      point = /(?<point>#{Point.regexp})/o
      same = /(?<same>同)\p{blank}*/

      /
        #{triangle}?
        (#{point}#{same}|#{same}#{point}|#{point}|#{same}) # 12同 or 同12 or 12 or 同 に対応
        (?<piece>#{Piece.all_names.join("|")})
        (?<motion_part>[左右直]?[寄引上行]?)
        (?<trigger_part>不?成|打|合|生)?
        (?<point_from>\(\d{2}\))? # scan の結果を join したものがマッチした元の文字列と一致するように () も含める
      /ox
    end

    def csa_regexp
      csa_basic_names = Piece.collect(&:csa_basic_name).compact.join("|")
      csa_promoted_names = Piece.collect(&:csa_promoted_name).compact.join("|")

      /
        (?<sign>[+-])?
        (?<csa_from>[0-9]{2}) # 00 = 駒台
        (?<csa_to>[1-9]{2})
        ((?<csa_basic_name>#{csa_basic_names})|(?<csa_promoted_name>#{csa_promoted_names}))
      /ox
    end

    def usi_regexp
      chars = Piece.collect(&:sfen_char).compact.join
      point = /[1-9][[:lower:]]/

      part1 = /(?<usi_direct_piece>[#{chars}])(?<usi_direct>\*)(?<usi_to>#{point})/o
      part2 = /(?<usi_from>#{point})(?<usi_to>#{point})(?<usi_promote_trigger>\+)?/o

      /((#{part1})|(#{part2}))/o
    end
  end
end
