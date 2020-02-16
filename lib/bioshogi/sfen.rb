# frozen-string-literal: true

module Bioshogi
  class Sfen
    STARTPOS_EXPANSION = "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"

    attr_reader :attributes
    attr_reader :source

    def self.parse(source)
      new(source).tap(&:parse)
    end

    def initialize(source)
      @source = source
    end

    def parse
      s = source.sub(/startpos/, STARTPOS_EXPANSION)
      md = s.match(/position\s+sfen\s+(?<board>\S+)\s+(?<b_or_w>\S+)\s+(?<hold_pieces>\S+)\s+(?<turn_counter_next>\d+)(\s+moves\s+(?<moves>.*))?/)
      unless md
        raise SyntaxDefact, "構文が不正です : #{source.inspect}"
      end
      @attributes = md.named_captures.symbolize_keys
    end

    def soldiers
      BoardParser::SfenBoardParser.parse(attributes[:board]).soldiers
    end

    def location
      Location.fetch(attributes[:b_or_w])
    end

    def piece_counts
      hash = Location.inject({}) { |a, e| a.merge(e.key => {}) }
      if str = attributes[:hold_pieces]
        if str != "-"
          str.scan(/(\d+)?(.)/) do |count, ch|
            count = (count || 1).to_i
            piece = Piece.fetch_by_sfen_char(ch)
            location = Location.fetch_by_sfen_char(ch)
            hash[location.key].update(piece.key => count) { |_, *c| c.sum }
          end
        end
      end
      hash
    end

    # 現在の局面+1が記載されているので -1 すること
    def turn_counter
      if v = attributes[:turn_counter_next]
        v.to_i.pred
      end
    end

    def handicap?
      turn_counter.even? && location.key == :white
    end

    def move_infos
      attributes[:moves].to_s.split.collect do |e|
        {input: e}
      end
    end
  end
end
