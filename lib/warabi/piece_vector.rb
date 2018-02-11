# frozen-string-literal: true
#
# basic_once_vectors      通常の1ベクトル
# basic_repeat_vectors    通常の繰り返しベクトル
# promoted_once_vectors   成ったときの1ベクトル
# promoted_repeat_vectors 成ったときの繰り返しベクトル
#
module Warabi
  class PieceVector
    include ApplicationMemoryRecord
    memory_record [
      {key: :king,   basic_once_vectors: :pattern_king,       basic_repeat_vectors: nil,           promoted_once_vectors: nil,           promoted_repeat_vectors: nil,           },
      {key: :rook,   basic_once_vectors: nil,                 basic_repeat_vectors: :pattern_plus, promoted_once_vectors: :pattern_x,    promoted_repeat_vectors: :pattern_plus, },
      {key: :bishop, basic_once_vectors: nil,                 basic_repeat_vectors: :pattern_x,    promoted_once_vectors: :pattern_plus, promoted_repeat_vectors: :pattern_x,    },
      {key: :gold,   basic_once_vectors: :pattern_gold,       basic_repeat_vectors: nil,           promoted_once_vectors: nil,           promoted_repeat_vectors: nil,           },
      {key: :silver, basic_once_vectors: :pattern_silver,     basic_repeat_vectors: nil,           promoted_once_vectors: :pattern_gold, promoted_repeat_vectors: nil,           },
      {key: :knight, basic_once_vectors: [[-1, -2], [1, -2]], basic_repeat_vectors: nil,           promoted_once_vectors: :pattern_gold, promoted_repeat_vectors: nil,           },
      {key: :lance,  basic_once_vectors: nil,                 basic_repeat_vectors: [[0, -1]],     promoted_once_vectors: :pattern_gold, promoted_repeat_vectors: nil,           },
      {key: :pawn,   basic_once_vectors: [[0, -1]],           basic_repeat_vectors: nil,           promoted_once_vectors: :pattern_gold, promoted_repeat_vectors: nil,           },
    ]

    def brave?
      attributes[:promoted_repeat_vectors]
    end

    def all_vectors(promoted:, location:)
      @all_vectors ||= {}
      @all_vectors[[promoted, location.key]] ||= -> {
        vectors = __select_vectors(promoted)
        normalized_vectors(location, vectors)
      }.call
    end

    private

    def __select_vectors(promoted)
      piece.assert_promotable(promoted)

      if promoted
        promoted_vectors
      else
        basic_vectors
      end
    end

    def piece
      Piece.fetch(key)
    end

    def normalized_vectors(location, vectors)
      if location.white?
        vectors = vectors.collect(&:reverse_sign)
      end
      vectors
    end

    def basic_vectors
      @basic_vectors ||= build_vectors(basic_once_vectors, basic_repeat_vectors)
    end

    def promoted_vectors
      @promoted_vectors ||= build_vectors(promoted_once_vectors, promoted_repeat_vectors)
    end

    def build_vectors(ov, rv)
      v = ov.compact + rv.compact
      if v.size != v.uniq.size
        raise MustNotHappen
      end

      [
        *ov.compact.collect { |v| OnceVector[*v]   },
        *rv.compact.collect { |v| RepeatVector[*v] },
      ].to_set
    end

    def basic_once_vectors
      __vectors_at(super)
    end

    def basic_repeat_vectors
      __vectors_at(super)
    end

    def promoted_once_vectors
      __vectors_at(super)
    end

    def promoted_repeat_vectors
      __vectors_at(super)
    end

    def __vectors_at(value)
      if value
        if value.kind_of?(Symbol)
          send(value)
        else
          value
        end
      else
        []
      end
    end

    def pattern_plus
      [
        nil,    [0,-1],   nil,
        [-1, 0],       [1, 0],
        nil,    [0, 1],   nil,
      ]
    end

    def pattern_x
      [
        [-1, -1], nil, [1, -1],
        nil,      nil,     nil,
        [-1,  1], nil, [1,  1],
      ]
    end

    def pattern_silver
      [
        [-1, -1], [0, -1], [1, -1],
        nil,          nil,     nil,
        [-1,  1],     nil, [1,  1],
      ]
    end

    def pattern_gold
      [
        [-1, -1], [0, -1], [1, -1],
        [-1,  0],          [1,  0],
        nil,      [0,  1],     nil,
      ]
    end

    def pattern_king
      [
        [-1, -1], [0, -1], [1, -1],
        [-1,  0],     nil, [1,  0],
        [-1,  1], [0,  1], [1,  1],
      ]
    end
  end
end
