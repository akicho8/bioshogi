# frozen-string-literal: true
module Warabi
  class Sfen
    STARTPOS = "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"

    attr_reader :attributes
    attr_reader :source

    def self.parse(source)
      new(source).tap(&:parse)
    end

    def initialize(source)
      @source = source
    end

    def parse
      s = source.sub(/startpos/, STARTPOS)
      md = s.match(/position\s+sfen\s+(?<sfen>\S+)\s+(?<b_or_w>\S+)\s+(?<hold_pieces>\S+)\s+(?<turn_counter_next>\d+)(\s+moves\s+(?<moves>.*))?/)
      unless md
        raise SyntaxDefact, "構文が不正です : #{source.inspect}"
      end
      @attributes = md.named_captures.symbolize_keys
    end

    def soldiers
      [].tap do |soldiers|
        attributes[:sfen].split("/").each.with_index do |row, y|
          x = 0
          row.scan(/(\+?)(.)/) do |promoted, ch|
            point = Point.fetch([x, y])
            if ch.match?(/\d+/)
              x += ch.to_i
            else
              location = Location.fetch_by_sfen_char(ch)
              promoted = (promoted == "+")
              piece = Piece.fetch_by_sfen_char(ch)
              soldiers << Soldier[piece: piece, point: point, location: location, promoted: promoted]
              x += 1
            end
          end
        end
      end
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

    def turn_counter
      if attributes[:turn_counter_next]
        attributes[:turn_counter_next].to_i.pred
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
