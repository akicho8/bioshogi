module Bioshogi
  class V
    module PresetVectors
      ################################################################################ 軸反転

      def reverse_x
        @reverse_x ||= self[-1, 1]
      end

      def reverse_y
        @reverse_y ||= -reverse_x
      end

      ################################################################################ ＋

      def right
        @right ||= self[1, 0]
      end

      def down
        @down ||= self[0, 1]
      end

      def up
        @up ||= -down
      end

      def left
        @left ||= -right
      end

      ################################################################################ ×

      def up_left
        @up_left ||= up + left
      end

      def up_right
        @up_right ||= up + right
      end

      def down_left
        @down_left ||= down + left
      end

      def down_right
        @down_right ||= down + right
      end

      ################################################################################ 汎用

      # 十
      def cross_vectors
        @cross_vectors ||= [up, right, down, left]
      end

      # ×
      def saltire_vectors
        @saltire_vectors ||= [up_left, up_right, down_left, down_right]
      end

      # □
      def outer_vectors
        @outer_vectors ||= cross_vectors + saltire_vectors
      end

      # ←→
      def left_right_vectors
        @left_right_vectors ||= [left, right]
      end

      ################################################################################ 一間竜

      def right_right
        @right_right ||= right + right
      end

      def left_left
        @left_left ||= left + left
      end

      def up_up
        @up_up ||= up + up
      end

      def down_down
        @down_down ||= down + down
      end

      ################################################################################ 桂馬

      def up_up_right
        @up_up_right ||= up + up + right
      end

      def up_up_left
        @up_up_left ||= up + up + left
      end

      ################################################################################ 継ぎ桂

      def down_down_right
        @down_down_right ||= down + down + right
      end

      def down_down_left
        @down_down_left ||= down + down + left
      end

      ################################################################################ 銀ばさみ

      def right_right_up
        @right_right_up ||= right + right + up
      end

      def left_left_up
        @left_left_up ||= left + left + up
      end

      ################################################################################

      def wariuchi_vectors
        @wariuchi_vectors ||= [down_left, down_right]
      end

      def ikkenryu_cross_vectors
        @ikkenryu_cross_vectors ||= [left_left, right_right, up_up, down_down]
      end

      def keima_vectors
        @keima_methods ||= [up_up_left, up_up_right]
      end

      def ginbasami_verctors
        @ginbasami_verctors ||= [[right, right_right, right_right_up], [left, left_left, left_left_up]]
      end

      def tsugikei_vectors
        @tsugikei_methods ||= [down_down_right, down_down_left]
      end

      def tasuki_vectors
        @tasuki_vectors ||= [[up_left, down_right], [up_right, down_left]]
      end

      def bishop_up_diagonal_vectors
        @bishop_up_diagonal_vectors ||= [up_left, up_right]
      end

      ################################################################################

      def anaguma_vectors(left_or_right)
        public_send(:"#{left_or_right}_anaguma_vectors")
      end

      ################################################################################

      def left_anaguma_vectors
        @left_anaguma_vectors ||= left_anaguma_vectors1 + left_anaguma_vectors2
      end

      # 外周
      def left_anaguma_vectors1
        @left_anaguma_vectors1 ||= [up, up + right, right]
      end

      # 外周の外周
      def left_anaguma_vectors2
        @left_anaguma_vectors2 ||= [up + up, up + up + right, up + up + right + right, up + right + right, right + right]
      end

      ################################################################################

      def right_anaguma_vectors
        @right_anaguma_vectors ||= right_anaguma_vectors1 + right_anaguma_vectors2
      end

      def right_anaguma_vectors1
        @right_anaguma_vectors1 ||= left_anaguma_vectors1.collect { |e| e * reverse_x }
      end

      def right_anaguma_vectors2
        @right_anaguma_vectors2 ||= left_anaguma_vectors2.collect { |e| e * reverse_x }
      end

      ################################################################################
    end
  end
end
