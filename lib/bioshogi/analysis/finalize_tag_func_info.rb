# frozen-string-literal: true

module Bioshogi
  module Analysis
    class FinalizeTagFuncInfo
      include ApplicationMemoryRecord
      memory_record [
        ################################################################################

        {
          key: "名人に定跡なし",
          description: "「力戦」より前に判定する",
          func: -> {
            if win_side_location
              player = container.player_at(win_side_location)
              if player.tag_bundle.attack_and_defense_is_blank?
                player.tag_bundle << "名人に定跡なし"
              end
            end
          },
        },
        {
          key: "力戦",
          func: -> {
            container.players.each do |e|
              if e.tag_bundle.attack_and_defense_is_blank?
                e.tag_bundle << "力戦"
              end
            end
          },
        },

        ################################################################################

        {
          key: "居飛車",
          func: -> {
            container.players.each do |e|
              if !e.tag_bundle.include?("振り飛車") && !e.tag_bundle.include?("居飛車")
                e.tag_bundle << "居飛車"
              end
            end
          },
        },
        {
          key: "相居飛車",
          func: -> {
            if container.players.all? { |e| e.tag_bundle.include?("居飛車") }
              container.players.each do |e|
                e.tag_bundle << "相居飛車"
              end
            end
          },
        },
        # {
        #   key: "対居飛車",
        #   func: -> {
        #     container.players.each do |e|
        #       if e.opponent_player.tag_bundle.include?("居飛車")
        #         e.tag_bundle << "対居飛車"
        #       end
        #     end
        #   },
        # },
        {
          key: "相振り飛車",
          func: -> {
            if container.players.all? { |e| e.tag_bundle.include?("振り飛車") }
              container.players.each do |e|
                e.tag_bundle << "相振り飛車"
              end
            end
          },
        },
        {
          key: "対抗形",
          description: "片方だけが「振り飛車」なら両方に「対抗形」",
          func: -> {
            if player = container.players.find { |e| e.tag_bundle.include?("振り飛車") }
              others = container.players - [player]
              if others.none? { |e| e.tag_bundle.include?("振り飛車") }
                container.players.each do |e|
                  e.tag_bundle << "対抗形"
                end
              end
            end
          },
        },

        ################################################################################

        {
          key: "○○系",
          func: -> {
            # container.players.each do |e|
            #   items = e.tag_bundle.attack_infos.unwant_rejected_ancestors
            #   CategoryInfo.each do |c|
            #     if items.any? { |e| e.root == c.object }
            #       e.tag_bundle << c.self_push
            #       e.opponent_player.tag_bundle << c.opponent_push
            #     end
            #   end
            # end

            # container.players.each do |e|
            #   e.tag_bundle.to_all_flat_array.each do |item|
            #     if item.respond_to?(:category)
            #       if v = item.category
            #         e.tag_bundle << v
            #       end
            #     end
            #     if item.respond_to?(:sub_category)
            #       if v = item.sub_category
            #         Array(v).each do |v|
            #           e.tag_bundle << v
            #         end
            #       end
            #     end
            #   end
            # end
          },
        },

        {
          key: "雁木削除",
          description: "雁木の出だしから振り飛車になった場合に雁木を削除する",
          func: -> {
            container.players.each do |player|
              if player.tag_bundle.include?("振り飛車")
                if player.tag_bundle.include?("雁木戦法")
                  player.tag_bundle.delete_tag("雁木戦法")
                end
              end
            end
          },
        },

        ################################################################################

        {
          key: "居玉",
          description: "一度も動かなかった or または戦いが激しくなってから動いた",
          func: -> {
            container.players.each do |e|
              if e.king_first_moved_turn.nil? || e.king_first_moved_turn >= container.outbreak_turn
                e.tag_bundle << "居玉"
              end
            end
          },
        },
        {
          key: "相居玉",
          func: -> {
            if container.players.all? { |e| e.tag_bundle.include?("居玉") }
              container.players.each do |e|
                e.tag_bundle << "相居玉"
              end
            end
          },
        },

        ################################################################################

        {
          key: "急戦・持久戦",
          func: -> {
            if container.outbreak_turn < Stat::OUTBREAK_TURN_AVG
              tag = "急戦"
            else
              tag = "持久戦"
            end
            container.players.each do |e|
              e.tag_bundle << tag
            end
          },
        },
        {
          key: "短手数・長手数",
          func: -> {
            if container.turn_info.turn_offset < Stat::TURN_MAX_AVG
              tag = "短手数"
            else
              tag = "長手数"
            end
            container.players.each do |e|
              e.tag_bundle << tag
            end
          },
        },

        ################################################################################

        {
          key: "屍の舞",
          description: "大駒がない状態で勝った場合",
          func: -> {
            if win_side_location
              player = container.player_at(win_side_location)
              if player.strong_piece_have_count.zero?         # 最後の状態でも全ブッチ状態なら
                if player.tag_bundle.include?("大駒全ブッチ") # 途中、大駒全ブッチしいて (←これがないと 相入玉.kif でも入ってしまう)
                  player.tag_bundle << "屍の舞"
                end
              end
            end
          },
        },
        {
          key: "穴熊の姿焼",
          func: -> {
            SugatayakiDetector.new(self).call
          },
        },

        {
          key: "相穴熊",
          func: -> {
            tag = Analysis::TagIndex.fetch("穴熊")
            if container.players.all? { |e| e.tag_bundle.include?(tag) }
              container.players.each do |player|
                player.tag_bundle << "相穴熊"
              end
            end
          },
        },
        {
          key: "相入玉",
          func: -> {
            tag = Analysis::TagIndex.fetch("入玉")
            if container.players.all? { |e| e.tag_bundle.include?(tag) }
              container.players.each do |player|
                player.tag_bundle << "相入玉"
              end
            end
          },
        },

        {
          key: "ロケット",
          func: -> {
            group_info = Analysis::GroupInfo["ロケット"]
            container.players.each do |e|
              if e.tag_bundle.all_tags.any? { |e| e.group_info == group_info }
                e.tag_bundle << "ロケット"
              end
            end
          },
        },

        ################################################################################

        {
          key: "都詰め",
          func: -> {
            if soldier = container.board["55"]
              if soldier.piece.key == :king
                if container.lose_player.location == soldier.location
                  container.win_player.tag_bundle << "都詰め"
                  if hand_log = container.hand_logs.last
                    hand_log.tag_bundle << "都詰め"
                  end
                end
              end
            end
          },
        },
        {
          key: "吊るし桂",
          func: -> {
            if hand_log = container.hand_logs.last
              if hand_log.soldier.piece.key == :knight
                container.win_player.tag_bundle << "吊るし桂"
                hand_log.tag_bundle << "吊るし桂"
              end
            end
          },
        },
        {
          key: "雪隠詰め",
          func: -> {
            if container.params[:input_last_action_info]&.last_checkmate_p
              soldier = container.lose_player.king_soldier
              if soldier.bottom_spaces == 0 && soldier.side_edge?
                container.win_player.tag_bundle << "雪隠詰め"
                if hand_log = container.hand_logs.last
                  hand_log.tag_bundle << "雪隠詰め"
                end
              end
            end
          },
        },

        ################################################################################
      ]
    end
  end
end
