module Bioshogi
  class V
    module PresetVectors
      ################################################################################

      def around_vectors
        @around_vectors ||= [up, right, down, left]
      end

      def left_right_vectors
        @left_right_vectors ||= [left, right]
      end

      def wariuchi_vectors
        @wariuchi_vectors ||= [down_left, down_right]
      end

      def ikkenryu_vectors
        @ikkenryu_vectors ||= [right_right, left_left, up_up, down_down]
      end

      def keima_vectors
        @keima_methods ||= [up_up_right, up_up_left]
      end

      def ginbasami_verctors
        @ginbasami_verctors ||= [[right, right_right, right_right_up], [left,  left_left,   left_left_up]]
      end

      def tsugikei_vectors
        @tsugikei_methods ||= [down_down_right, down_down_left]
      end

      def tasuki_vectors
        @tasuki_vectors ||= [[up_left, down_right], [up_right, down_left]]
      end

      def bishop_naname_mae_vectors
        @bishop_naname_mae_vectors ||= [up_left, up_right]
      end

      ################################################################################ 上下左右

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

      ################################################################################ 斜め

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

      ################################################################################ 継ぎ桂チェック用

      def down_down_right
        @down_down_right ||= down + down + right
      end

      def down_down_left
        @down_down_left ||= down + down + left
      end

      ################################################################################ 銀ばさみチェック用

      def right_right_up
        @right_right_up ||= right + right + up
      end

      def left_left_up
        @left_left_up ||= left + left + up
      end

      ################################################################################
    end
  end
end
