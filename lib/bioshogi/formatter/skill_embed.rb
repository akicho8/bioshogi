# frozen-string-literal: true

module Bioshogi
  module Formatter
    class SkillEmbed
      MIN_TURN = 14             # これ以上の手数だと対局が成立している見なす

      attr_accessor :xparser
      attr_accessor :container

      def initialize(xparser, container)
        @xparser = xparser
        @container = container
      end

      def call
        miyakodume_check
        rikisen_judgement

        # 両方が入玉していれば「相入玉」タグを追加する
        # この場合、両方同時に入玉しているかどうかは判定できない
        ainyugyoku_judgement

        if @xparser.preset_info
          if @xparser.preset_info.special_piece
            ibisha_judgement    # 振り飛車でなければ居飛車(最初に判定する)
            aiibisha_judgement  # 両方居飛車なら相居飛車
            taiibisya_judgement # 相手が居飛車なら対居飛車
            aihuri_judgement   # 両方振り飛車なら相振り
            taikoukei_judgement  # 片方だけが「振り飛車」なら、振り飛車ではない方に「対振り飛車」。両方に「対抗形」
            haisui_judgement   # 大駒がない状態で勝ったら「背水の陣」
            igyoku_judgement   # 居玉判定
            aiigyoku_judgement # 相居玉判定
            kyusen_judgement   # 急戦・持久戦
            tantesuu_judgement # 短手数・長手数
          end
        end

        header_write
      end

      private

      def rikisen_judgement
        # return if ENV["BIOSHOGI_ENV"] == "test"
        if @container.turn_info.display_turn >= MIN_TURN
          # @container.players.each do |player|
          #   if player.skill_set.power_battle?
          #     ChaosInfo.each do |chaos_info|
          #       if chaos_info.if_cond[@container]
          #         player.skill_set.list_push(AttackInfo[chaos_info.key])
          #         break
          #       end
          #     end
          #   end
          # end
          # if @container.players.all? { |e| e.skill_set.power_battle? }
          #   @container.players.each do |e|
          #     e.skill_set.list_push(AttackInfo["乱戦"])
          #   end
          # else
          @container.players.each do |e|
            e.skill_set.rikisen_check_process
          end
          # end
        end
      end

      def miyakodume_check
        if last_action_params = @xparser.pi.last_action_params
          if last_action_key = last_action_params[:last_action_key]
            if last_action_info = LastActionInfo[last_action_key]
              if last_action_info.key == :TSUMI
                if soldier = @container.board["55"]
                  if soldier.piece.key == :king
                    tag = Explain::NoteInfo["都詰め"]
                    if @container.lose_player.location == soldier.location
                      @container.win_player.skill_set.list_push(tag)
                      # 最後の手にも入れておく
                      if hand_log = @container.hand_logs.last
                        hand_log.skill_set.list_push(tag)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      def ainyugyoku_judgement
        if @container.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["入玉"]) }
          @container.players.each do |player|
            player.skill_set.list_push(Explain::NoteInfo["相入玉"])
          end
        end
      end

      # 振り飛車でなければ居飛車
      def ibisha_judgement
        @container.players.each do |e|
          skill_set = e.skill_set
          if !skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) && !skill_set.has_skill?(Explain::NoteInfo["居飛車"])
            e.skill_set.list_push(Explain::NoteInfo["居飛車"])
          end
        end
      end

      def aiibisha_judgement
        # 両方居飛車なら相居飛車
        if @container.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["居飛車"]) }
          @container.players.each do |player|
            player.skill_set.list_push(Explain::NoteInfo["相居飛車"])
          end
        end
      end

      def taiibisya_judgement
        # 相手が居飛車なら対居飛車
        @container.players.each do |player|
          if player.opponent_player.skill_set.has_skill?(Explain::NoteInfo["居飛車"])
            player.skill_set.list_push(Explain::NoteInfo["対居飛車"])
          end
        end
      end

      def aihuri_judgement
        # 両方振り飛車なら相振り
        if @container.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
          @container.players.each do |player|
            player.skill_set.list_push(Explain::NoteInfo["相振り飛車"])
          end
        end
      end

      def taikoukei_judgement
        # 片方だけが「振り飛車」なら両方に「対抗形」
        if player = @container.players.find { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
          others = @container.players - [player]
          if others.none? { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
            @container.players.each { |e| e.skill_set.list_push(Explain::NoteInfo["対抗形"]) }
          end
        end
      end

      # 大駒がない状態で勝ったら「背水の陣」
      def haisui_judgement
        # 入玉の場合「指した方が負け」になるケースがあり win_player が信用できなくなるため、
        # 勝ち負けがついた終わり方をしたとき (win_or_lose_p) のときだけとする
        if @xparser.pi.win_or_lose_p
          @container.players.each do |player|
            if player == @container.win_player # 入玉の場合「指した方が負け」になるケースがあるため win_player が信用できない
              if player.stronger_piece_have_count.zero?
                player.skill_set.list_push(Explain::NoteInfo["背水の陣"])
              end
            end
          end
        end
      end

      # 居玉判定
      def igyoku_judgement
        @container.players.each do |e|
          enabled = false
          # 14手以上の対局で一度も動かずに終了した
          unless enabled
            if @container.turn_info.display_turn >= MIN_TURN && e.king_moved_counter.zero?
              enabled = true
            end
          end
          # 歩と角以外の交換があったか？
          unless enabled
            if @container.outbreak_turn
              v = e.king_first_moved_turn
              if v.nil? || v >= @container.outbreak_turn  # 玉は動いていない、または戦いが激しくなってから動いた
                enabled = true
              end
            end
          end
          if enabled
            e.skill_set.list_push(Explain::DefenseInfo["居玉"])
          end
        end
      end

      def aiigyoku_judgement
        # 両方居玉だったら備考に相居玉
        if @container.players.all? { |e| e.skill_set.has_skill?(Explain::DefenseInfo["居玉"]) }
          @container.players.each do |e|
            e.skill_set.list_push(Explain::NoteInfo["相居玉"])
          end
        end
        # end
      end

      def kyusen_judgement
        if turn = @container.outbreak_turn
          if turn < Stat::OUTBREAK_TURN_AVG
            key = "急戦"
          else
            key = "持久戦"
          end
          @container.players.each do |e|
            e.skill_set.list_push(Explain::NoteInfo[key])
          end
        end
      end

      def tantesuu_judgement
        if @container.critical_turn # 1回でも駒の交換があった
          max = @container.turn_info.display_turn
          if max >= MIN_TURN
            if max < Stat::TURN_MAX_AVG
              key = "短手数"
            else
              key = "長手数"
            end
            @container.players.each do |e|
              e.skill_set.list_push(Explain::NoteInfo[key])
            end
          end
        end
      end

      def header_write
        Explain::TacticInfo.each do |e|
          @container.players.each do |player|
            list = player.skill_set.public_send(e.list_key).normalize
            if v = list.presence
              v = v.uniq # 手筋の場合、複数になる場合があるので uniq する
              key = "#{player.call_name}の#{e.name}"
              @xparser.skill_set_hash[key] = v.collect(&:name)
            end
          end
        end
        hv = @xparser.skill_set_hash.transform_values { |e| e.join(", ") }
        @xparser.pi.header.object.update(hv)
      end
    end
  end
end
