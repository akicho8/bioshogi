# frozen-string-literal: true

module Bioshogi
  module Formatter
    concern :HeaderBuilder do
      def header_part_string
        @header_part_string ||= __header_part_string
      end

      private

      def __header_part_string
        mediator_run

        m = initial_mediator

        if e = m.board.preset_info
          header["手合割"] = e.name

          # 手合割がわかるとき持駒が空なら消す
          Location.each do |e|
            e.call_names.each do |e|
              key = "#{e}の持駒"
              if v = header[key]
                if v.blank?
                  header.delete(key)
                end
              end
            end
          end

          raw_header_part_string
        else
          # 手合がわからないので図を出す場合
          # 2つヘッダー行に挟む形になっている仕様が特殊でデータの扱いが難しい
          # header["手合割"] ||= "その他"

          bod = m.to_bod(display_turn_skip: true, compact: true)

          # >> 後手の持駒：銀 歩三
          # >> 先手の持駒：角 歩
          # を削除する
          Location.each do |e|
            header.delete("#{e.call_name(m.turn_info.handicap?)}の持駒")
          end

          # Location.reverse_each do |e|
          #   key = "#{e.call_name(m.turn_info.handicap?)}の持駒"
          #   if v = header.delete(key)
          #     header[key] = v
          #   end
          # end

          # 「なし」を埋める
          # Location.each do |location|
          #   key = "#{location.call_name(m.turn_info.handicap?)}の持駒"
          #   v = header[key]
          #   if v.blank?
          #     header[key] = "なし"
          #   end
          # end

          # 駒落ちの場合は「上手」「下手」の順に並べる (盤面をその間に入れるため)
          # Location.reverse_each do |e|
          #   key = "#{e.call_name(m.turn_info.handicap?)}の持駒"
          #   if v = header.delete(key)
          #     header[key] = v
          #   end
          # end

          # 後手の持駒：○○
          # 先手の持駒：○○
          #
          # の間に盤面を埋める
          #
          s = raw_header_part_string + bod

          # embed_str = m.board.to_s
          # key = "#{Location[:white].call_name(m.turn_info.handicap?)}の持駒"
          # s = s.sub(/(#{key}：.*\n)/, '\1' + embed_str)
          #
          # embed_str = nil
          # v = mediator.turn_info.turn_base
          # if v >= 1
          #   embed_str = "\n手数＝#{v}\n"
          # end
          # if embed_str
          #   key = "#{Location[:black].call_name(m.turn_info.handicap?)}の持駒"
          #   s = s.sub(/(#{key}：.*\n)/, '\1' + embed_str)
          # end

          s
        end
      end

      def raw_header_part_string
        s = raw_header_part_hash.collect { |key, value| "#{key}：#{value}\n" }.join

        if @parser_options[:support_for_piyo_shogi_v4_1_5]
          s = s.gsub(/(の持駒：.*)$/, '\1 ')
        end

        s

      end
    end
  end
end
