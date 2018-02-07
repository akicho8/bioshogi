# frozen-string-literal: true

module Warabi
  class PieceBox
    attr_accessor :counts

    delegate :to_h, :clear, to: :counts

    def initialize(**hash)
      @counts = hash
    end

    def pick_out(piece)
      piece = Piece.fetch(piece)
      if (counts[piece.key] || 0) <= 0
        raise HoldPieceNotFound, "#{piece.name}がありません : #{to_h.inspect}"
      end
      counts[piece.key] -= 1
      if counts[piece.key] <= 0
        counts.delete(piece.key)
      end
      piece
    end

    def pick_out_without_king
      Piece.h_to_a(counts.except(:king))
    end

    def pieces
      Piece.h_to_a(counts)
    end

    def exist?(piece)
      piece = Piece.fetch(piece)
      counts.has_key?(piece.key)
    end

    def add(hash)
      counts.update(hash) { |_, *c| c.sum }
    end

    def set(hash)
      counts.replace(hash)
    end

    def normalize
      counts.reject! { |_, c| c <= 0 }
    end

    def to_s(**options)
      Piece.h_to_s(counts, options)
    end

    def to_sfen(location)
      location = Location[location]
      counts.flat_map { |key, count|
        [(count >= 2 ? count : nil), Piece.fetch(key).to_sfen(location: location)]
      }.join
    end

    def to_csa(location)
      if counts.empty?
        return ""
      end
      location = Location[location]
      counts = self.counts.transform_keys { |e| Piece.fetch(e) }
      counts = counts.sort_by { |piece, _| -piece.basic_weight }
      ["P", location.csa_sign, counts.flat_map { |piece, count| ["00", piece.csa_basic_name] * count }].join
    end
  end
end
