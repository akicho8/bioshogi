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
    def moveable_points(player, mini_soldier, options = {})
      options = {
        board_object_collision_skip: false, # 盤上の他の駒を考慮しない？
        with_promoted: false,               # 成って行けるのかどうかの情報を付加する
      }.merge(options)
      list = []
      if options[:with_promoted]
        list += moveable_points_block(player, mini_soldier, mini_soldier[:point], mini_soldier[:piece].step_vectors(mini_soldier[:promoted]), false, options)
        list += moveable_points_block(player, mini_soldier, mini_soldier[:point], mini_soldier[:piece].series_vectors(mini_soldier[:promoted]), true, options)
        list.uniq{|e|e.to_xy}     # 龍などは step_vectors と series_vectors で左右上下が重複しているため
      else
        list += moveable_points_block(player, mini_soldier, mini_soldier[:point], mini_soldier[:piece].step_vectors(mini_soldier[:promoted]), false, options)
        list += moveable_points_block(player, mini_soldier, mini_soldier[:point], mini_soldier[:piece].series_vectors(mini_soldier[:promoted]), true, options)
        list.uniq{|e|e.to_xy}     # 龍などは step_vectors と series_vectors で左右上下が重複しているため
      end
    end

    private

    def moveable_points_block(player, mini_soldier, point, vectors, loop, options)
      normalized_vectors(player, vectors).each.with_object([]) do |vector, list|
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
              if options[:with_promoted]
                ways = moveable_points(player, mini_soldier.merge(point: pt), board_object_collision_skip: true)
                p ways
                # TODO: ここで何も取得できなかったらいきどまりなので、成フラグをいっしょに座標を返さないといけない
              end
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
        v = Vector[*vector]
        if player.location.white?
          v = v.reverse_sign
        end
        v
      end
    end
  end
end
