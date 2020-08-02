# frozen-string-literal: true

module Bioshogi
  class PieceBox < SimpleDelegator
    ALL_PIECES = "玉2飛2角2金4銀4桂4香4歩18"

    def self.default_pieces
      @default_pieces ||= Piece.s_to_h(ALL_PIECES).freeze
    end
    private_class_method :default_pieces

    def self.all_in_create
      new(default_pieces)
    end

    def initialize(value = {})
      super(value.dup)
    end

    def pick_out(piece)
      piece = Piece.fetch(piece)
      unless exist?(piece)
        raise HoldPieceNotFound, "#{piece.name}を持っていません : #{to_h}"
      end
      add(piece => -1)
      piece
    end

    def pick_out_without_king
      Piece.h_to_a(object.except(:king))
    end

    def pieces
      Piece.h_to_a(object)
    end

    def exist?(piece)
      piece = Piece.fetch(piece)
      (object[piece.key] || 0).positive?
    end

    def add(hash)
      hash.each do |key, c|
        piece = Piece.fetch(key)
        n = object[piece.key] || 0
        new_c = n + c
        if new_c.positive?
          object[piece.key] = new_c
        elsif new_c.negative?
          raise HoldPieceNotFound, "#{piece.name}は#{n}しかないのに#{c}したので#{new_c}になりました : #{to_h}"
        else
          object.delete(piece.key)
        end
      end
      self
    end

    def safe_add(hash)
      hash.each do |key, count|
        object[key] = (object[key] || 0) + count
      end
      self
    end

    def safe_sub(hash)
      hash.each do |key, count|
        object[key] = (object[key] || 0) - count
      end
      self
    end

    def set(hash)
      object.replace(hash)
    end

    def normalize!
      object.reject! { |_, c| c <= 0 }
    end

    def score
      object.collect { |piece_key, count|
        Piece[piece_key].hold_weight * count
      }.sum
    end

    def detail_score
      object.collect { |piece_key, count|
        piece = Piece[piece_key]
        {piece: piece.name, count: count, weight: piece.hold_weight, total: piece.hold_weight * count}
      }
    end

    def pressure_level
      object.sum { |piece_key, count| Piece[piece_key].standby_level * count }
    end

    ################################################################################ formatter

    def to_s(options = {})
      Piece.h_to_s(object, options)
    end

    def to_sfen(location)
      location = Location[location]
      object.flat_map { |key, count|
        [(count >= 2 ? count : nil), Piece.fetch(key).to_sfen(location: location)]
      }.join
    end

    def to_csa(location)
      if object.empty?
        return ""
      end
      location = Location[location]
      c = object.collect { |piece_key, count| [Piece.fetch(piece_key), count] }
      c = c.sort_by { |piece, _| -piece.basic_weight }
      ["P", location.csa_sign, c.flat_map { |piece, count| ["00", piece.csa.basic_name] * count }].join
    end

    private

    def object
      __getobj__
    end
  end
end
