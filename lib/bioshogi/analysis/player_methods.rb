# frozen-string-literal: true

module Bioshogi
  module Analysis
    module PlayerMethods
      attr_accessor :king_moved_counter
      attr_accessor :king_place
      attr_accessor :king_first_moved_turn # 玉が最初に動いた手数

      def king_moved_counter
        @king_moved_counter ||= 0
      end

      # 玉の位置
      # FIXME: 消す
      def king_place
        @king_place ||= king_soldier&.place
      end

      def king_place_update
        @king_place = king_soldier&.place
      end

      def used_piece_counts
        @used_piece_counts ||= Hash.new(0)
      end

      def to_header_h
        acc = {}

        Analysis::TacticInfo.each do |e|
          if v = tag_bundle.value(e).normalize.presence
            acc["#{call_name}の#{e.name}"] = v.collect(&:name).join(", ")
          end
        end

        if container.params[:preset_info_or_nil]
          if main_style_info = tag_bundle.main_style_info
            acc["#{call_name}の棋風"] = main_style_info.name
          end
        end

        acc["#{call_name}の玉移動"] = "#{king_moved_counter}回"

        acc
      end
    end
  end
end
