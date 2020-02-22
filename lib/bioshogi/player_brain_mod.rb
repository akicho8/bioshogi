module Bioshogi
  concern :PlayerBrainMod do
    def evaluator(**options)
      (options[:evaluator_class] || Evaluator::Level1).new(self, options)
    end

    def brain(**params)
      Brain.new(self, **params)
    end

    # 非合法手を含む(ピンを考慮しない)すべての指し手の生成
    def create_all_hands(**options)
      Enumerator.new do |y|
        move_hands(options).each do |e|
          y << e
        end
        drop_hands(options).each do |e|
          y << e
        end
      end
    end

    # ピンを考慮した合法手の生成
    #
    # ▼PinCheck機構つきのMakeMoveの提案 - Bonanzaソース完全解析ブログ
    # http://d.hatena.ne.jp/LS3600/20091229
    # > MakeMoveのあとに王手がかかっているかを調べてはならない
    # > MakeMove → InCheck(自王に王手がかかっているかを判定)→(自玉に王手がかかっているなら) UnMakeMove というのは良くない
    # > それというのも、MakeMoveでは局面ハッシュ値やoccupied bitboardなどを更新したりしているのが普通であり、王手がかかっているのがわかってから局面を戻すというのは無駄なやりかただ。
    #
    # 枝刈りされる前の状態でピンを考慮すると重すぎて動かないのでどこにこのチェックを入れるかが難しい
    #
    def legal_all_hands(**options)
      create_all_hands(options.merge(legal_only: true))
    end

    # 盤上の駒の全手筋
    def move_hands(**options)
      options = {
        promoted_only: false,      # 成と不成がある場合は成だけを生成する？
        king_captured_only: false, # 玉を取る手だけ生成する？
        legal_only: false,         # 合法手のみ生成する？ (移動することで自玉に利きが通ってしまう手を除くか？)
        mate_only: false,          # 王手だけに絞る？
      }.merge(options)

      Enumerator.new do |y|
        soldiers.each do |soldier|
          soldier.move_list(mediator, options).each do |move_hand|
            y << move_hand
          end
        end
      end
    end

    # 持駒の全打筋
    def drop_hands(**options)
      options = {
        rule_valid: true,         # 合法手のみ(二歩と死に駒以外)生成する？
        legal_only: false,        # 合法手のみ生成する？ (打つことで自玉が死ぬ手を除く。そんな手ある？)
        mate_only: false,         # 王手だけに絞る？
      }.merge(options)

      Enumerator.new do |y|
        # 直接 piece_box.each_key とせずに piece_keys にいったん取り出している理由は
        # 外側で execute 〜 revert するときの a.each { a.update } の状態になるのを回避するため。
        # each の中で元を更新すると "can't add a new key into hash during iteration" のエラーになる
        piece_keys = piece_box.keys
        board.blank_places.each do |place|
          piece_keys.each do |piece_key|
            soldier = Soldier.create(piece: Piece[piece_key], promoted: false, place: place, location: location)

            if options[:rule_valid]
              # 二歩と死に駒なら除外
              if !soldier.rule_valid?(board)
                next
              end
            end

            drop_hand = DropHand.create(soldier: soldier)

            if options[:legal_only]
              # 合法手でなければ除外
              if !drop_hand.legal_hand?(mediator)
                next
              end
            end

            if options[:mate_only]
              # 王手がかからない手を除外
              if !drop_hand.mate_hand?(mediator)
                next
              end
            end

            y << drop_hand
          end
        end
      end
    end

    # 相手に対して王手をしている手の取得
    # Enumerator なので mate_move_hands.first で最初の1件の処理だけになる
    def mate_move_hands
      # move_hands(promoted_only: true, king_captured_only: true, legal_only: true)
      move_hands(promoted_only: true, king_captured_only: true)
    end

    # 王手をかけている？
    def mate_advantage?
      mate_move_hands.any?
    end

    # 王手をかけられている？
    def mate_danger?
      opponent_player.mate_advantage?
    end

    private

    def move_list(soldier, **options)
      Movabler.move_list(mediator, soldier, options)
    end
  end
end
