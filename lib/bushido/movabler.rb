# -*- coding: utf-8 -*-
#
# 動けるか確認
#   どのクラスでも使うので
#   どのクラスに入れたらいいのかわからん
#   ので別のモジュールにしてみる
#
module Bushido
  module Movabler
    extend self

    # vectors1, vectors2 と分けるのではなくベクトル自体に繰り返しフラグを持たせる方法も検討
    def moveable_points(player, point, piece, promoted, options = {})
      options = {
        :board_object_collision_skip => false, # 盤上の他の駒を考慮しない？
      }.merge(options)
      list = []
      list += moveable_points_block(player, point, piece.vectors1(promoted), false, options)
      list += moveable_points_block(player, point, piece.vectors2(promoted), true, options)
      list.uniq{|e|e.to_xy}     # 龍などは vectors1 と vectors2 で左右上下が重複しているため
    end

    private

    def moveable_points_block(player, point, vectors, loop, options)
      normalized_vectors(player, vectors).each_with_object([]) do |vector, list|
        pt = point
        loop do
          pt = pt.add_vector(vector)
          unless pt.valid?
            break
          end
          if options[:board_object_collision_skip]
            list << pt
          else
            target = player.board.fetch(pt)
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

    def normalized_vectors(player, vectors)
      vectors.uniq.compact.collect do |vector|
        if player.location.white?
          vector = Vector.new(vector).reverse
        end
        vector
      end
    end
  end
end
