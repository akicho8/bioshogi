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

    # step_vectors, series_vectors と分けるのではなくベクトル自体に繰り返しフラグを持たせる方法も検討
    def moveable_points(player, point, piece, promoted, options = {})
      options = {
        :board_object_collision_skip => false, # 盤上の他の駒を考慮しない？
      }.merge(options)
      list = []
      list += moveable_points_block(player, point, piece.step_vectors(promoted), false, options)
      list += moveable_points_block(player, point, piece.series_vectors(promoted), true, options)
      list.uniq{|e|e.to_xy}     # 龍などは step_vectors と series_vectors で左右上下が重複しているため
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
            target = player.board_fetch_as_soldier(pt)
            if target.nil?
              list << pt
            else
              unless Soldier === target
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
