# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class OutekakuDetector < OutebishaDetector
        def own_piece
          :rook
        end

        def own_piece_vector
          :cross_vectors
        end

        def target_piece
          :bishop
        end

        def tag_first
          "王手角"
        end

        def tag_second
          "準王手角"
        end

        def tag_third
          "飛車による両取り"
        end
      end
    end
  end
end
