# -*- coding: utf-8 -*-
#
# 盤上の駒
#
module Bushido
  class Soldier
    attr_accessor :player, :piece, :promoted, :point

    def initialize(player, piece, promoted = false)
      @player = player
      @piece = piece
      self.promoted = promoted
    end

    # 成り/不成状態の設定
    def promoted=(promoted)
      if !@piece.promotable? && promoted
        raise NotPromotable, "成れない駒で成ろうとしています : #{piece.inspect}"
      end
      @promoted = promoted
    end

    def to_s(format = :default)
      send("to_s_#{format}")
    end

    def to_s_default
      "#{piece_current_name}#{@player.location.zarrow}"
    end

    def inspect
      "<#{self.class.name}:#{object_id} #{formality_name}>"
    end

    [:promoted].each{|key|
      if public_method_defined?(key)
        define_method("#{key}?"){public_send(key)}
      end
    }

    # 駒の名前
    def piece_current_name
      @piece.some_name(@promoted)
    end

    # 正式な棋譜の表記で返す
    #  Player.basic_test(:init => "５五と").board["５五"].formality_name # => "▲5五と"
    def formality_name
      "#{@player.location.mark}#{point ? point.name : '(どこにも置いてない)'}#{self}"
    end

    # 自分が保持している座標ではなく盤面から自分を探す (デバッグ用)
    def read_point
      if xy = @player.board.surface.invert[self]
        Point.parse(xy)
      end
    end

    # vectors1, vectors2 と分けるのではなくベクトル自体に繰り返しフラグを持たせる方法も検討
    def moveable_points(options = {})
      options = {
        :board_object_collision_skip => false, # 盤上の他の駒を考慮しない？
      }.merge(options)
      list = []
      list += moveable_points_block(@piece.vectors1(@promoted), false, options)
      list += moveable_points_block(@piece.vectors2(@promoted), true, options)
      list.uniq{|e|e.to_xy}     # 龍などは vectors1 と vectors2 で左右上下が重複しているため
    end

    # 二歩チェック。
    # 置こうとしているのが歩で、同じ縦列に自分の歩があればエラーとする。
    def double_pawn_validation(board, point)
      if piece.kind_of?(Piece::Pawn) && !promoted
        point.y.class.units.each{|y|
          if s = board.fetch(Point.parse([point.x, y]))
            if s.player == player
              if piece.class == s.piece.class && !s.promoted
                raise DoublePawn, "二歩です。#{s.formality_name}があるため#{point.name}に#{self}は打てません。"
              end
            end
          end
        }
      end
    end

    private

    def normalized_vectors(vectors)
      vectors.uniq.compact.collect do |vector|
        if player.location.white?
          vector = Vector.new(vector).reverse
        end
        vector
      end
    end

    def moveable_points_block(vectors, loop, options)
      normalized_vectors(vectors).each_with_object([]) do |vector, list|
        pt = point
        loop do
          pt = pt.add_vector(vector)
          unless pt.valid?
            break
          end
          if options[:board_object_collision_skip]
            list << pt
          else
            target = @player.board.fetch(pt)
            if target.nil?
              list << pt
            else
              unless target.kind_of?(Soldier)
                raise UnconfirmedObject, "得体の知れないものが盤上にいます : #{target.inspect}"
              end
              # 自分の駒は追い抜けない(駒の所有者が自分だったので追い抜けない)
              if target.player == player
                break
              else
                # 相手の駒だったので置ける
                list << pt
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
