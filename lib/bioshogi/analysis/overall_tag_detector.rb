# frozen-string-literal: true

module Bioshogi
  module Analysis
    class OverallTagDetector
      attr_accessor :container

      def initialize(container)
        @container = container
      end

      def call
        OverallTagInfo.each do |e|
          if v = e.turn_gteq
            unless container.turn_info.turn_offset >= v
              next
            end
          end
          if v = e.preset_has
            unless container.params[:preset_info_or_nil]&.public_send(v)
              next
            end
          end
          if e.critical
            unless container.critical_turn
              next
            end
          end
          if e.outbreak
            unless container.outbreak_turn
              next
            end
          end
          if e.checkmate
            unless container.params[:last_action_info].last_checkmate_p
              next
            end
          end
          instance_exec(&e.func)
        end
      end

      def win_side_location
        @win_side_location ||= yield_self do
          if v = container.params[:win_side_location]
            # 勝者が明示されている場合
            # SHOGI-EXTEND 側からは常に勝者を入れている
            # これは切断されたときどちらが切断してどちらが勝ったのか手番では判断できないため
            v
          elsif container.params[:last_action_info].win_player_collect_p
            # 明示されていないかつ「投了」「時間切れ」「詰み」で終わった場合のみ、手番による勝者を信じる
            # これは入玉の場合「指した方が負け」になるケースがあるため、入玉などは除外しないといけない
            container.win_player.location
          end
        end
      end
    end
  end
end
