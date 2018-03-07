# frozen-string-literal: true
module Warabi
  module Movabler
    extend self

    # soldier が移動可能な手をすべて取得する
    #
    # アルゴリズム
    #
    #     １       １
    #   +---+    +---+
    #   | ・|一  | ・|一
    #   | ・|二  | ・|二
    #   | 香|三  | 杏|三
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
    def move_list(board, soldier, **options)
      Enumerator.new do |yielder|
        soldier.all_vectors.each do |vector|
          place = soldier.place
          loop do
            place = place.vector_add(vector)

            # 盤外に出たら終わり
            if place.invalid?
              break
            end

            captured_soldier = board.surface[place]

            # 自分の駒に衝突したら終わり
            if captured_soldier && captured_soldier.location == soldier.location
              break
            end

            # 空または相手駒の升には行ける
            piece_store(soldier, place, captured_soldier, yielder, options)

            # 相手駒があるのでこれ以上は進めない
            if captured_soldier
              break
            end

            # 一歩だけベクトルならそれで終わり
            if vector.kind_of?(OnceVector)
              break
            end
          end
        end
      end
    end

    private

    # place の場所は空なので player の soldier を place に置けそうだ
    # でも place に置いてそれ以上動けなかったら反則になるので
    # 1. それ以上動けるなら置く
    # 2. 成れるなら成ってみて、それ以上動けるなら置く
    def piece_store(origin_soldier, place, captured_soldier, yielder, options)
      # 死に駒にならないのであれば有効
      soldier = origin_soldier.merge(place: place)

      # 成れるなら成る
      if origin_soldier.next_promotable?(soldier.place)
        yielder << MoveHand.create(soldier: soldier.merge(promoted: true), origin_soldier: origin_soldier, captured_soldier: captured_soldier)

        if options[:promoted_preferred]
          return
        end
      end

      if soldier.alive?
        yielder << MoveHand.create(soldier: soldier, origin_soldier: origin_soldier, captured_soldier: captured_soldier)
      end
    end
  end
end
