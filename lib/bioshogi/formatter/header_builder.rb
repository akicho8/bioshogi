# frozen-string-literal: true

module Bioshogi
  module Formatter
    concern :HeaderBuilder do
      def header_part_string
        @header_part_string ||= __header_part_string
      end

      private

      def __header_part_string
        mediator_run_once

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
          # また駒落ちなのに「先手」の名前の場合もあるので区別せずに削除する
          Location.each do |e|
            e.call_names.each do |e|
              header.delete("#{e}の持駒")
            end
          end
          s = raw_header_part_string + bod
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
