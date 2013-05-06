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
      list = []
      list += moveable_points_block(player, mini_soldier, mini_soldier[:piece].select_vectors(mini_soldier[:promoted]), options)
      # list.each{|e|e.update(:origin_soldier => mini_soldier)}
      list.uniq{|e|e.to_s}
    end

    # step_vectors, series_vectors と分けるのではなくベクトル自体に繰り返しフラグを持たせる方法も検討
    def moveable_points2(player, mini_soldier, options = {})
      list = []
      list += moveable_points_block2(player, mini_soldier, mini_soldier[:piece].select_vectors(mini_soldier[:promoted]), options)
      list.uniq{|e|e.to_s} # FIXME: もしかして同じものがあるかも。あとで確認
    end

    private

    # アルゴリズム
    #
    #     １       １
    #   +---+    +---+
    #   | ・|一  | ・|一
    #   | ・|二  | ・|二
    #   | 香|三  | 杏 |三
    #   +---+    +---+
    #
    #   ▲１三香の場合
    #   A. "１二" に移動してみて、その状態でさらに動けるなら "１二香" をストアしつつ、成れるなら成ってさらに動けるなら "１二杏" もストア
    #   B. "１一" に移動してみて、その状態でさらに動けるなら "１一杏" をストアしつつ、成れるなら成ってさらに動けるなら "１三杏" をストア
    #
    #   ▲１三杏 の場合
    #   C. "１二" に移動してみて、その状態でさらに動けるなら "１二杏" をストア。動けないので成れるなら成って→成れない
    #   D. "１一" に移動してみて → 移動できない
    #
    #   となるので成っているかどうかにかかわらず B の方法でやればいい
    #
    def moveable_points_block(player, mini_soldier, vecs, options)
      normalized_vectors(player, vecs).each.with_object([]) do |vec, list|
        pt = mini_soldier[:point]
        loop do
          pt = pt.add_vector(vec)
          unless pt.valid?
            break
          end
          target = player.board.fetch(pt)
          if target.nil?
            func2(list, player, mini_soldier, pt)
          else
            unless Soldier === target
              raise UnconfirmedObject, "得体の知れないものが盤上にいます : #{target.inspect}"
            end
            # 自分の駒は追い抜けない(駒の所有者が自分だったので追い抜けない)
            if target.player == player
              break
            else
              # 相手の駒だったので置ける
              func2(list, player, mini_soldier, pt)
              break
            end
          end
          if OnceVector === vec
            break
          end
        end
      end
    end

    def func2(list, player, mini_soldier, pt)
      m = mini_soldier.merge(point: pt)
      ways = moveable_points2(player, m)
      if !ways.empty?
        list << SoldierMove[m.merge(:origin_soldier => mini_soldier)]
      end
      if m.sarani_nareru?(player.location)
        m = m.merge(promoted: true)
        ways = moveable_points2(player, m)
        if !ways.empty?
          list << SoldierMove[m.merge(:origin_soldier => mini_soldier, :promoted_trigger => true)]
        end
      end
    end

    def moveable_points_block2(player, mini_soldier, vecs, options)
      normalized_vectors(player, vecs).each.with_object([]) do |vec, list|
        pt = mini_soldier[:point]
        loop do
          pt = pt.add_vector(vec)
          if pt.valid?
            list << mini_soldier.merge(:point => pt)
          else
            break
          end
          if OnceVector === vec
            break
          end
        end
      end
    end

    def normalized_vectors(player, vecs)
      vecs.collect do |v|
        if player.location.white?
          v = v.reverse_sign
        end
        v
      end
    end
  end
end
