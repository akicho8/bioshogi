# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :StyleAccessor do
      class_methods do
        def style_reject_keys
          # [:"力戦", :"居玉"].to_set
          [].to_set
        end

        def styles_hash
          @styles_hash ||= yield_self do
            list = values.reject { |e| style_reject_keys.include?(e.key) }
            # list = list.take(7)
            list = list.sort_by { |e| -e.frequency }
            backets = Array.new(list.size, StyleInfo.count.pred) # 正確に四分割できないため「変態」で埋める
            step = list.size / StyleInfo.count
            StyleInfo.count.pred.times do |i|
              range = (i * step)...(i.next * step)
              backets.fill(i, range)                # 最初の3区分を 0, 1, 2, で埋める
            end
            list.each_with_object({}).with_index do |(e, m), i|
              m[e.key] = StyleInfo.fetch(backets[i])
            end
          end
        end
      end

      # 王道 or 変態
      # 新しい戦法を追加したばかりのときはテーブルにない場合がある？ → 必ずある
      # なぜなら最初に新しい戦法を追加するのは bioshogi 側なため。
      # したがってない場合を心配する必要はない。
      def style_info
        self.class.styles_hash.fetch(key)
      end

      # 使用数
      # これは Frequency にない場合もあるため、ない場合に 0 を返すのは正しい。
      def frequency
        Frequency[key] || 0
      end
    end
  end
end
