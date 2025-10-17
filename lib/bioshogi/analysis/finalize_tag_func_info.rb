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
          key: "雁木削除",
          description: "雁木の出だしから振り飛車になった場合のみ雁木を削除する (例外的措置)",
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
          key: "持将棋埋め込み",
          func: -> {
            if input_last_action_info = container.params[:input_last_action_info]
              if input_last_action_info.jishogi_p
                container.players.each do |player|
                  player.tag_bundle << "持将棋"
                  # 最終手で持将棋になったは限らないため最終手に持将棋を入れるのはおかしい
                  if false
                    if hand_log = container.hand_logs.last
                      hand_log.tag_bundle << "持将棋"
                    end
                  end
                end
              end
            end
          },
        },
        {
          key: "屍の舞",
          description: "大駒がない状態で勝った場合",
          func: -> {
            if win_side_location
              player = container.player_at(win_side_location)
              if player.hisyakaku_piece_have_count.zero?         # 最後の状態でも全ブッチ状態なら
                if player.tag_bundle.include?("大駒全ブッチ") # 途中、大駒全ブッチしいて (←これがないと 相入玉.kif でも入ってしまう)
                  player.tag_bundle << "屍の舞"
                end
              end
            end
          },
        },
        {
          key: "穴熊の姿焼き",
          func: -> {
            SugatayakiDetector.new(self).call
          },
        },
        {
          key: "駒得は何か",
          description: "大きく駒得して勝ったか、または大きく駒得しているにかかわらず負けた",
          func: -> {
            if win_side_player
              diff = score_info[:diff]
              threshold = Analysis::ClusterScoreInfo["駒得は正義の閾値"].min_score
              case
              when diff > threshold # 大きく駒得した状態で勝った
                win_side_player.tag_bundle << "駒得は正義"
              when diff < -threshold # 相手の方が大きく駒得していたのにこちらが勝った
                lose_side_player.tag_bundle << "駒の持ち腐れ"
              end
            end
          },
        },
        {
          key: "道場出禁判定",
          description: "超短手数かつ圧倒的な差で負けた or 玉単騎 or 全駒",
          func: -> {
            if win_side_player
              if container.turn_info.turn_offset < Stat::TURN_MAX_AVG / 2 # 89.4866 / 2
                # 当初は大駒2枚分を捨てたときに出禁とするつもりだった
                # 実際には互いの差なので大駒1枚で2枚分の差がついていた
                # なので想定の倍、道場出禁判定になってしまっている
                # けどまぁそれでもいいことにする
                if score_info[:diff] >= Analysis::ClusterScoreInfo["道場出禁の閾値"].min_score
                  lose_side_player.tag_bundle << "道場出禁"
                end
              end
            end

            if win_side_player
              container.players.each do |player|
                if player.tag_bundle.include?("玉単騎") || player.tag_bundle.include?("全駒")
                  player.tag_bundle << "道場出禁"
                end
              end
            end
          },
        },
        {
          key: "ミニマリスト判定",
          description: "持駒なしかつ盤上の駒が初期状態より減っている",
          func: -> {
            if win_side_player
              if win_side_player.piece_box.empty?
                if preset_info = container.params[:preset_info_or_nil]
                  default_piece_count = preset_info.location_split[win_side_player.location.key].size
                  if win_side_player.soldiers.count < default_piece_count
                    win_side_player.tag_bundle << "ミニマリスト"
                  end
                end
              end
            end
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
