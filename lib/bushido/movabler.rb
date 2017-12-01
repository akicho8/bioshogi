# frozen-string-literal: true
#
# 動けるか確認
#   どのクラスでも使うので
#   どのクラスに入れたらいいのかわからん
#   ので別のモジュールにしてみる
#
module Bushido
  module Movabler
    extend self

    # player の soldier が移動可能な手をすべて取得する
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
    def movable_infos(player, soldier)
      Enumerator.new do |yielder|
        vecs = soldier[:piece].select_vectors2(soldier.slice(:promoted, :location))
        vecs.each do |vec|
          pt = soldier[:point]
          loop do
            pt = pt.vector_add(vec)

            # 盤外に出てしまったら終わり
            if pt.invalid?
              break
            end

            target = player.board.lookup(pt)

            if target && !target.kind_of?(Battler)
              raise UnconfirmedObject, "盤上に得体の知れないものがいます : #{target.inspect}"
            end

            # 自分の駒に衝突したら終わり
            if target && target.player == player
              break
            end

            # 自分の駒以外(相手駒 or 空)なので行ける
            piece_store(player, soldier, pt, yielder)

            # 相手駒があるのでこれ以上は進めない
            if target
              break
            end

            # 一歩だけベクトルならそれで終わり
            if vec.kind_of?(OnceVector)
              break
            end
          end
        end
      end
    end

    # player の soldier が vecs の方向(複数)へ移動できるか？
    #  ・とてもシンプル
    #  ・相手の盤上の駒を考慮しない
    #  ・自分の盤上の駒も考慮しない
    #  ・さらに成れるかどうか考慮しない
    #  ・桂を1の行にジャンプしたときにそれ以上移動できないので「１一桂」はダメという場合に使う
    #  ・だから OnceVector か RepeatVector か見る必要はない
    #  ・行ける方向に一歩でも行ける可能性があればよい
    def alive_piece?(soldier)
      raise MustNotHappen unless soldier[:location]
      vectors = soldier[:piece].select_vectors2(soldier.slice(:promoted, :location))
      vectors.any? do |v|
        soldier[:point].vector_add(v).valid?
      end
    end

    private

    # pt の場所は空なので player の soldier を pt に置けそうだ
    # でも pt に置いてそれ以上動けなかったら反則になるので
    # 1. それ以上動けるなら置く
    # 2. 成れるなら成ってみて、それ以上動けるなら置く
    def piece_store(player, soldier, pt, yielder)
      # それ以上動けるなら置く
      m = soldier.merge(point: pt)
      if alive_piece?(m)
        yielder << BattlerMove[m.merge(origin_battler: soldier)]
      end
      # 成れるなら成ってみて
      if m.more_promote?(player.location)
        m = m.merge(promoted: true)
        # それ以上動けるなら置く
        if alive_piece?(m)
          yielder << BattlerMove[m.merge(origin_battler: soldier, promoted_trigger: true)]
        end
      end
    end
  end
end
