# frozen-string-literal: true

module Bioshogi
  class PieceBox < SimpleDelegator
    ONE_SIDE_PIECES = "玉飛角金2銀2桂2香2歩9"

    class << self
      def real_box
        new(all_piece_counts)
      end

      private

      def all_piece_counts
        @all_piece_counts ||= Piece.s_to_h(ONE_SIDE_PIECES * 2).freeze
      end
    end

    def initialize(value = {})
      super(value.dup)
    end

    def pick_out(piece)
      piece = Piece.fetch(piece)
      if !exist?(piece)
        raise HoldPieceNotFound, "持駒から#{piece.name}を取り出そうとしましたが#{piece.name}を持っていません : #{to_h}"
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

    # http://yaneuraou.yaneu.com/2016/07/15/sfen%E6%96%87%E5%AD%97%E5%88%97%E3%81%AF%E4%B8%80%E6%84%8F%E3%81%AB%E5%AE%9A%E3%81%BE%E3%82%89%E3%81%AA%E3%81%84%E4%BB%B6/#:~:text=%E2%86%92%202016%2F7%2F15%2024,%E6%AD%A9%E3%80%8D%E3%81%AE%E9%A0%86%E7%95%AA%E3%81%A8%E3%81%97%E3%81%BE%E3%81%99%E3%80%82
    def to_sfen(location)
      location = Location[location]
      sorted_piece_objects_hash.sort_by { |piece, _|
        -piece.basic_weight
      }.flat_map { |piece, count|
        [(count >= 2 ? count : ""), piece.to_sfen(location: location)]
      }.join
    end

    def to_csa(location)
      if object.empty?
        return ""
      end
      location = Location[location]
      [
        "P",
        location.csa_sign,
        sorted_piece_objects_hash.flat_map { |piece, count|
          ["00", piece.csa.basic_name] * count
        },
      ].join
    end

    private

    def sorted_piece_objects_hash
      object.collect { |key, count|
        [Piece.fetch(key), count]
      }.sort_by { |piece, _|
        -piece.basic_weight
      }
    end

    def object
      __getobj__
    end
  end
end
