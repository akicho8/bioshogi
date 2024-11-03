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

      ################################################################################ 割り打ち

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

      ################################################################################
    end
  end
end
