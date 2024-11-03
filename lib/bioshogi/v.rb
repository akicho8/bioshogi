module Bioshogi
  class V
    class << self
      def one
        @one ||= self[1, 1]
      end

      def half
        @half ||= self[0.5, 0.5]
      end

      def [](...)
        new(...)
      end

      ################################################################################

      def around_vectors
        @around_vectors ||= [up, right, down, left]
      end

      def up
        @up ||= self[0, -1]
      end

      def right
        @right ||= self[1, 0]
      end

      def left
        @left ||= self[-1, 0]
      end

      def down
        @down ||= self[0, 1]
      end

      ################################################################################ 一間竜の状態

      def ikkenryu_vectors
        @ikkenryu_vectors ||= [right2, left2, up2, down2] # 左右を先に持ってくると気持ち程度速くなる
      end

      def right2
        @right2 ||= right * 2
      end

      def left2
        @left2 ||= left * 2
      end

      def up2
        @up2 ||= up * 2
      end

      def down2
        @down2 ||= down * 2
      end

      ################################################################################ 桂馬の動き

      def keima_ways
        @keima_methods ||= [up_up_right, up_up_left]
      end

      def up_up_right
        @up_up_right ||= self[1, -2]
      end

      def up_up_left
        @up_up_left ||= self[-1, -2]
      end

      ################################################################################
    end

    attr_reader :x
    attr_reader :y

    def initialize(x, y)
      @x = x
      @y = y
      freeze
    end

    include Enumerable
    delegate :each, to: :to_a

    def to_a
      [@x, @y]
    end

    def to_ary
      to_a
    end

    def ==(other)
      @x == other.x && @y == other.y
    end

    def hash
      @x.hash ^ @y.hash
    end

    def eql?(other)
      instance_of?(other.class) && @x == other.x && @y == other.y
    end

    def <=>(other)
      to_a <=> other.to_a
    end

    %i(+ - * /).each do |op|
      class_eval <<-EOT, __FILE__, __LINE__ + 1
        def #{op}(other)                                        # def +(other)
          if other.kind_of?(self.class)                         #   if other.kind_of?(self.class)
            self.class.new(@x #{op} other.x, @y #{op} other.y)  #     self.class.new(@x + other.x, @y + other.y)
          else                                                  #   else
            self.class.new(@x #{op} other, @y #{op} other)      #     self.class.new(@x + other, @y + other)
          end                                                   #   end
        end                                                     # end
      EOT
    end

    def -@
      self * -1
    end

    def to_s
      to_a.to_s
    end

    def inspect
      "<#{self}>"
    end
  end
end
