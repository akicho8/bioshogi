# frozen-string-literal: true

module Bioshogi
  module Formatter
    concern :HeaderBuilder do
      # def header_part_string
      #   @header_part_string ||= header_part_string_build
      # end
      #
      # private
      #
      # def header_part_string_build
      #   mediator_run_once
      #
      #   m = initial_mediator
      #
      #   if e = m.board.preset_info
      #     # 手合割がわかる場合
      #     header["手合割"] = e.name
      #     mochigoma_delete_if_blank # 手合割がわかるとき持駒が空なら消す
      #     raw_header_part_string
      #   else
      #     # ".*の持駒" を消してBODを埋める
      #     mochigoma_delete_force
      #     raw_header_part_string + m.to_bod(display_turn_skip: true, compact: true)
      #   end
      # end
      #
      # def raw_header_part_string
      #   raw_header_part_hash.collect { |key, value| "#{key}：#{value}\n" }.join
      # end
      #
      # def mochigoma_delete_force
      #   Location.call_names.each do |e|
      #     header.delete("#{e}の持駒")
      #   end
      # end
      #
      # def mochigoma_delete_if_blank
      #   Location.call_names.each do |e|
      #     key = "#{e}の持駒"
      #     if v = header[key]
      #       if v.blank?
      #         header.delete(key)
      #       end
      #     end
      #   end
      # end
    end
  end
end
