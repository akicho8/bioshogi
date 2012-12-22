# -*- coding: utf-8 -*-
module Bushido
  class Soldier
    attr_accessor :player, :piece, :promoted

    def initialize(player, piece, promoted = false)
      @player = player
      @piece = piece
      @promoted = promoted

      if !piece.promotable? && promoted
        raise NotPromotable, piece.inspect
      end
    end

    def to_s
      "#{piece_current_name}#{@player.arrow}"
    end

    def piece_current_name
      @piece.some_name(@promoted)
    end

    def inspect
      "<#{self.class.name}:#{object_id} #{to_text}>"
    end

    def to_text
      "#{@player.location_mark}#{current_point ? current_point.name : '(どこにも置いてない)'}#{self}"
    end

    def name
      to_text
    end

    def current_point
      if xy = @player.board.matrix.invert[self]
        Point.parse(xy)
      end
    end

    # FIXME: vectors1, vectors2 と分けるのではなくベクトル自体に繰り返しフラグを持たせる方法も検討
    def moveable_points(options = {})
      options = {
        :ignore_the_other_pieces_on_the_board => false,
      }.merge(options)

      list = []
      list += __moveable_points(@piece.vectors1(@promoted), false, options)
      list += __moveable_points(@piece.vectors2(@promoted), true, options)
      list.uniq{|e|e.to_xy}     # FIXME: ブロックを取る
    end

    def normalized_vectors(vectors)
      vectors.uniq.compact.collect do |vector|
        if player.location == :white
          vector = Vector.new(vector).reverse
        else
          vector
        end
      end
    end

    def __moveable_points(vectors, loop, options = {})
      normalized_vectors(vectors).each_with_object([]) do |vector, list|
        point = current_point
        loop do
          point = point.add_vector(vector)
          unless point.valid?
            break
          end

          if options[:ignore_the_other_pieces_on_the_board]
            list << point
          else
            target = @player.board.fetch(point)
            if target.nil?
              list << point
            else
              unless target.kind_of? Soldier
                raise UnconfirmedObject, "得体の知れないものが盤上にいます : #{target.inspect}"
              end
              # 自分の駒は追い抜けない(駒の所有者が自分だったので追い抜けない)
              if target.player == player
                break
              else
                # 相手の駒だったので置ける
                list << point
                break
              end
            end
          end
          unless loop
            break
          end
        end
      end
    end
  end
end
