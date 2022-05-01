# frozen-string-literal: true
#
# 盤上にプレイヤーの特定の種類の駒が何個あるかを O(n) で調べる
# 大駒コンプリートのためだけにある
#
module Bioshogi
  module BoardPieceCountsMethods
    def place_on(soldier, options = {})
      super
      piece_counts[location_with_piece_key_from(soldier)] += 1 # soldier.piece.stronger をキーにすると速くなるかも？
    end

    def safe_delete_on(place)
      super.tap do |soldier|
        if soldier
          piece_counts[location_with_piece_key_from(soldier)] -= 1
        end
      end
    end

    def all_clear
      super
      piece_counts.clear
    end

    def piece_count_of(location_key, piece_key)
      piece_counts[[location_key, piece_key]]
    end

    private

    def piece_counts
      @piece_counts ||= Hash.new(0)
    end

    # promoted は見ていない
    def location_with_piece_key_from(soldier)
      [soldier.location.key, soldier.piece.key]
    end
  end
end
