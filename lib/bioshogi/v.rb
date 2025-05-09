module Bioshogi
  class V
    extend PresetVectors

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

    %i[+ - * /].each do |op|
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
