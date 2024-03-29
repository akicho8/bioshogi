module Bioshogi
  module Hand
    concern :Shared do
      included do
        include SimpleModel
        attr_accessor :soldier

        private_class_method :new
      end

      class_methods do
        def create(...)
          Bioshogi.run_counts["#{name}.#{__method__}"] += 1
          new(...).freeze
        end
      end

      def sandbox_execute(container, &block)
        begin
          execute(container)
          Bioshogi.run_counts["sandbox_execute.execute"] += 1
          yield
        ensure
          revert(container)
          Bioshogi.run_counts["sandbox_execute.revert"] += 1
        end
      end

      def type
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def to_kif(*)
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def to_csa(*)
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def to_sfen(*)
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def to_akf(*)
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def inspect
        "<#{self}>"
      end

      def to_s(options = {})
        to_kif(options)
      end

      def king_captured?
        respond_to?(:captured_soldier) && captured_soldier && captured_soldier.piece.key == :king
      end

      # 合法手か？
      # 指してみて自分に王手がかかってない状態なら合法手
      # 自分が何か指してみて→相手の駒を動かして自分の玉が取られる→非合法手
      #
      # Drop, Move 両方に必要
      # 王手をかけらている状態なら、打ってさえぎらないといけない
      # 王手をかけらている状態なら、動いてかわさないといけない
      # つまり両方チェックが必要
      # Move だけにしてしまうと王手をかけられた状態で無駄な打をしてしまう(王手放置)
      # このとき相手の玉に対して王手していると局面が不正ということになる。激指でも同様のエラーになった。
      #
      # 1. 駒を動かしたことで王手になっていないこと
      # 2. 王手の状態を回避したこと
      # の両方チェックするので↓この一つでよい。
      #
      def legal_hand?(container)
        sandbox_execute(container) do
          !container.player_at(soldier.location).mate_danger? # 「自玉に詰みがある」の反対
        end
      end

      # 王手か？
      def mate_hand?(container)
        sandbox_execute(container) do
          container.player_at(soldier.location.flip).mate_danger?
        end
      end

      # 使った駒とする soldier
      def soldier_for_counts
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      # 使った駒とする soldier を元にしたキー
      # もし「打ったかどうか」も調べるならここではなく個別のクラスで定義する
      def to_counts_key
        s = soldier_for_counts
        "#{s.piece.sfen_char}#{s.promoted ? 1 : 0}"
      end
    end
  end
end
