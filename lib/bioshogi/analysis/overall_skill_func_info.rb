# frozen-string-literal: true

module Bioshogi
  module Analysis
    class OverallSkillFuncInfo
      include ApplicationMemoryRecord
      memory_record [
        ################################################################################

        {
          key: "名人に定跡なし",
          description: "「力戦」より前に判定する",
          func: -> {
            if win_side_location
              player = @container.player_at(win_side_location)
              if player.skill_set.power_battle?
                player.skill_set.list_push2("名人に定跡なし")
              end
            end
          },
        },
        {
          key: "力戦",
          func: -> {
            @container.players.each do |e|
              if e.skill_set.power_battle?
                e.skill_set.list_push2("力戦")
              end
            end
          },
        },

        ################################################################################

        {
          key: "居飛車",
          func: -> {
            @container.players.each do |e|
              skill_set = e.skill_set
              if !skill_set.has_skill?(Analysis::NoteInfo["振り飛車"]) && !skill_set.has_skill?(Analysis::NoteInfo["居飛車"])
                e.skill_set.list_push2("居飛車")
              end
            end
          },
        },
        {
          key: "相居飛車",
          func: -> {
            tag = Analysis::TagIndex.fetch("居飛車")
            if @container.players.all? { |e| e.skill_set.has_skill?(tag) }
              @container.players.each do |player|
                player.skill_set.list_push2("相居飛車")
              end
            end
          },
        },
        {
          key: "対居飛車",
          func: -> {
            tag = Analysis::TagIndex.fetch("居飛車")
            @container.players.each do |player|
              if player.opponent_player.skill_set.has_skill?(tag)
                player.skill_set.list_push2("対居飛車")
              end
            end
          },
        },
        {
          key: "相振り飛車",
          func: -> {
            tag = Analysis::TagIndex.fetch("振り飛車")
            if @container.players.all? { |e| e.skill_set.has_skill?(tag) }
              @container.players.each do |player|
                player.skill_set.list_push2("相振り飛車")
              end
            end
          },
        },
        {
          key: "対抗形",
          description: "片方だけが「振り飛車」なら両方に「対抗形」",
          func: -> {
            tag = Analysis::TagIndex.fetch("振り飛車")
            if player = @container.players.find { |e| e.skill_set.has_skill?(tag) }
              others = @container.players - [player]
              if others.none? { |e| e.skill_set.has_skill?(tag) }
                @container.players.each do |e|
                  e.skill_set.list_push2("対抗形")
                end
              end
            end
          },
        },

        ################################################################################

        {
          key: "○○系",
          func: -> {
            # @container.players.each do |e|
            #   items = e.skill_set.attack_infos.unwant_rejected_ancestors
            #   CategoryInfo.each do |c|
            #     if items.any? { |e| e.root == c.object }
            #       e.skill_set.list_push2(c.self_push)
            #       e.opponent_player.skill_set.list_push2(c.opponent_push)
            #     end
            #   end
            # end

            # @container.players.each do |e|
            #   e.skill_set.to_all_flat_array.each do |item|
            #     if item.respond_to?(:category)
            #       if v = item.category
            #         e.skill_set.list_push(v)
            #       end
            #     end
            #     if item.respond_to?(:sub_category)
            #       if v = item.sub_category
            #         Array(v).each do |v|
            #           e.skill_set.list_push(v)
            #         end
            #       end
            #     end
            #   end
            # end
          },
        },

        ################################################################################

        {
          key: "居玉",
          description: "一度も動かなかった or または戦いが激しくなってから動いた",
          func: -> {
            @container.players.each do |e|
              if e.king_first_moved_turn.nil? || e.king_first_moved_turn >= @container.outbreak_turn
                e.skill_set.list_push2("居玉")
              end
            end
          },
        },
        {
          key: "相居玉",
          func: -> {
            tag = Analysis::TagIndex.fetch("居玉")
            if @container.players.all? { |e| e.skill_set.has_skill?(tag) }
              @container.players.each do |e|
                e.skill_set.list_push2("相居玉")
              end
            end
          },
        },

        ################################################################################

        {
          key: "急戦・持久戦",
          func: -> {
            if @container.outbreak_turn < Stat::OUTBREAK_TURN_AVG
              tag = "急戦"
            else
              tag = "持久戦"
            end
            @container.players.each do |e|
              e.skill_set.list_push2(tag)
            end
          },
        },
        {
          key: "短手数・長手数",
          func: -> {
            if @container.turn_info.turn_offset < Stat::TURN_MAX_AVG
              tag = "短手数"
            else
              tag = "長手数"
            end
            @container.players.each do |e|
              e.skill_set.list_push2(tag)
            end
          },
        },

        ################################################################################

        {
          key: "屍の舞",
          description: "大駒がない状態で勝った場合",
          func: -> {
            if win_side_location
              player = @container.player_at(win_side_location)
              if player.strong_piece_have_count.zero?                              # 最後の状態でも全ブッチ状態なら
                if player.skill_set.has_skill?(Analysis::NoteInfo["大駒全ブッチ"]) # 途中、大駒全ブッチしいて (←これがないと 相入玉.kif でも入ってしまう)
                  player.skill_set.list_push2("屍の舞")
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
            if @container.players.all? { |e| e.skill_set.has_skill?(tag) }
              @container.players.each do |player|
                player.skill_set.list_push2("相穴熊")
              end
            end
          },
        },
        {
          key: "相入玉",
          func: -> {
            tag = Analysis::TagIndex.fetch("入玉")
            if @container.players.all? { |e| e.skill_set.has_skill?(tag) }
              @container.players.each do |player|
                player.skill_set.list_push2("相入玉")
              end
            end
          },
        },
        {
          key: "ロケット",
          func: -> {
            @container.players.each do |player|
              technique_infos = player.skill_set.technique_infos
              if Analysis::TechniqueInfo.rocket_list.any? { |e| technique_infos.include?(e) }
                player.skill_set.list_push2("ロケット")
              end
            end
          },
        },

        ################################################################################

        {
          key: "都詰め",
          func: -> {
            if soldier = @container.board["55"]
              if soldier.piece.key == :king
                if @container.lose_player.location == soldier.location
                  @container.win_player.skill_set.list_push2("都詰め")
                  if hand_log = @container.hand_logs.last
                    hand_log.skill_set.list_push2("都詰め")
                  end
                end
              end
            end
          },
        },
        {
          key: "吊るし桂",
          func: -> {
            if hand_log = @container.hand_logs.last
              if hand_log.soldier.piece.key == :knight
                @container.win_player.skill_set.list_push2("吊るし桂")
                hand_log.skill_set.list_push2("吊るし桂")
              end
            end
          },
        },
        {
          key: "雪隠詰め",
          func: -> {
            found = ["11", "91", "19", "99"].any? do |e|
              if soldier = @container.board[e]
                if soldier.piece.key == :king
                  @container.lose_player.location == soldier.location
                end
              end
            end
            if found
              @container.win_player.skill_set.list_push2("雪隠詰め")
              if hand_log = @container.hand_logs.last
                hand_log.skill_set.list_push2("雪隠詰め")
              end
            end
          },
        },

        ################################################################################
      ]
    end
  end
end
