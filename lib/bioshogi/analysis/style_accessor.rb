# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :StyleAccessor do
      class_methods do
        # - 頻度0件の戦法が多いため0件の戦法は初期値「変態」としてテーブルには含めない
        # - 1件でも存在するものだけで4エリアで分けたテーブルを作る
        # - そこに含まれなかったものは「変態」とする
        # - こうすることでほとんどが王道になってしまうのを防ぐことができる
        def styles_hash
          @styles_hash ||= yield_self do
            # 分布数降順の戦法配列を準備する

            av = values
            av = av.find_all { |e| e.frequency >= 1 } # 1件以上のものに絞る
            av = av.sort_by { |e| -e.frequency }      # 分布数降順とする

            # テーブル作成

            backets = Array.new(av.size, StyleInfo.count.pred) # 正確に四分割できないため「変態」で埋める
            step = av.size / StyleInfo.count                   # 1区分の幅
            StyleInfo.count.pred.times do |i|                  # i = 0, 1, 2
              range = (i * step)...(i.next * step)
              backets.fill(i, range)                           # 最初の3区分を 0, 1, 2 で埋める
            end

            # 分布数降順の戦法に対応するスタイルを割り当てる

            av.each_with_object({}).with_index do |(e, m), i|
              m[e.key] = StyleInfo.fetch(backets[i])
            end
          end
        end
      end

      def style_info
        self.class.styles_hash[key] || StyleInfo.values.last
      end

      # 使用数
      # これは Frequency にない場合もあるため、ない場合に 0 を返すのは正しい。
      def frequency
        Frequency.dig(tactic_key, key) || 0
      end
    end
  end
end
