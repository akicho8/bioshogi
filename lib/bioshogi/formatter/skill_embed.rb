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
        tsurushikei_check
        settintsume_check

        meijin_judgement        # 力戦より前
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
            rocket_judgement   # N段ロケットがあれば「ロケット」
            SugatayakiValidator.new(self).call # 穴熊の姿焼
            igyoku_judgement   # 居玉判定
            aiigyoku_judgement # 相居玉判定
            kyusen_judgement   # 急戦・持久戦
            tantesuu_judgement # 短手数・長手数
            anaguma_judgement  # 穴熊・対穴熊
          end
        end

        header_write
      end

      # 勝った側を返す
      # nil の場合もある
      def win_side_location
        @win_side_location ||= @xparser.win_side_location(@container)
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

      def meijin_judgement
        if @container.turn_info.display_turn >= MIN_TURN
          if win_side_location
            player = @container.player_at(win_side_location)
            if player.skill_set.power_battle?
              player.skill_set.list_push(Analysis::NoteInfo[:"名人に定跡なし"])
            end
          end
        end
      end

      def miyakodume_check
        if @xparser.pi.saigoha_tsumi_p
          if soldier = @container.board["55"]
            if soldier.piece.key == :king
              if @container.lose_player.location == soldier.location
                tag = Analysis::NoteInfo["都詰め"]
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

      def settintsume_check
        if @xparser.pi.saigoha_tsumi_p
          found = ["11", "91", "19", "99"].any? do |e|
            if soldier = @container.board[e]
              if soldier.piece.key == :king
                @container.lose_player.location == soldier.location
              end
            end
          end
          if found
            tag = Analysis::NoteInfo["雪隠詰め"]
            @container.win_player.skill_set.list_push(tag)
            # 最後の手にも入れておく
            if hand_log = @container.hand_logs.last
              hand_log.skill_set.list_push(tag)
            end
          end
        end
      end

      def tsurushikei_check
        if @xparser.pi.saigoha_tsumi_p
          if hand_log = @container.hand_logs.last
            tag = Analysis::NoteInfo["吊るし桂"]
            if hand_log.soldier.piece.key == :knight
              @container.win_player.skill_set.list_push(tag) # 勝者に入れておく
              hand_log.skill_set.list_push(tag)              # 最後の手にも入れておく
            end
          end
        end
      end

      def ainyugyoku_judgement
        if @container.players.all? { |e| e.skill_set.has_skill?(Analysis::NoteInfo["入玉"]) }
          @container.players.each do |player|
            player.skill_set.list_push(Analysis::NoteInfo["相入玉"])
          end
        end
      end

      # 振り飛車でなければ居飛車
      def ibisha_judgement
        if @container.turn_info.display_turn >= MIN_TURN # 0手で切断した場合も「居飛車」とならないようにするため
          @container.players.each do |e|
            skill_set = e.skill_set
            if !skill_set.has_skill?(Analysis::NoteInfo["振り飛車"]) && !skill_set.has_skill?(Analysis::NoteInfo["居飛車"])
              e.skill_set.list_push(Analysis::NoteInfo["居飛車"])
            end
          end
        end
      end

      def aiibisha_judgement
        # 両方居飛車なら相居飛車
        if @container.players.all? { |e| e.skill_set.has_skill?(Analysis::NoteInfo["居飛車"]) }
          @container.players.each do |player|
            player.skill_set.list_push(Analysis::NoteInfo["相居飛車"])
          end
        end
      end

      def taiibisya_judgement
        # 相手が居飛車なら対居飛車
        @container.players.each do |player|
          if player.opponent_player.skill_set.has_skill?(Analysis::NoteInfo["居飛車"])
            player.skill_set.list_push(Analysis::NoteInfo["対居飛車"])
          end
        end
      end

      def aihuri_judgement
        # 両方振り飛車なら相振り
        if @container.players.all? { |e| e.skill_set.has_skill?(Analysis::NoteInfo["振り飛車"]) }
          @container.players.each do |player|
            player.skill_set.list_push(Analysis::NoteInfo["相振り飛車"])
          end
        end
      end

      def anaguma_judgement
        # 両方穴熊なら相穴熊
        if @container.players.all? { |e| e.skill_set.has_skill?(Analysis::NoteInfo["穴熊"]) }
          @container.players.each do |player|
            player.skill_set.list_push(Analysis::NoteInfo["相穴熊"])
          end
        end
      end

      def taikoukei_judgement
        # 片方だけが「振り飛車」なら両方に「対抗形」
        if player = @container.players.find { |e| e.skill_set.has_skill?(Analysis::NoteInfo["振り飛車"]) }
          others = @container.players - [player]
          if others.none? { |e| e.skill_set.has_skill?(Analysis::NoteInfo["振り飛車"]) }
            @container.players.each { |e| e.skill_set.list_push(Analysis::NoteInfo["対抗形"]) }
          end
        end
      end

      # 大駒がない状態で勝ったら「背水の陣」
      def haisui_judgement
        if @container.turn_info.display_turn >= MIN_TURN
          if win_side_location
            player = @container.player_at(win_side_location)
            if player.strong_piece_have_count.zero?                           # 最後の状態でも全ブッチ状態なら
              if player.skill_set.has_skill?(Analysis::NoteInfo["大駒全ブッチ"]) # 途中、大駒全ブッチしいて (←これがないと 相入玉.kif でも入ってしまう)
                player.skill_set.list_push(Analysis::NoteInfo["背水の陣"])
              end
            end
          end
        end
      end

      # N段ロケットがあれば「ロケット」
      def rocket_judgement
        @container.players.each do |player|
          technique_infos = player.skill_set.technique_infos
          if Analysis::TechniqueInfo.rocket_list.any? { |e| technique_infos.include?(e) }
            player.skill_set.list_push(Analysis::NoteInfo["ロケット"])
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
            e.skill_set.list_push(Analysis::DefenseInfo["居玉"])
          end
        end
      end

      def aiigyoku_judgement
        # 両方居玉だったら備考に相居玉
        if @container.players.all? { |e| e.skill_set.has_skill?(Analysis::DefenseInfo["居玉"]) }
          @container.players.each do |e|
            e.skill_set.list_push(Analysis::NoteInfo["相居玉"])
          end
        end
        # end
      end

      def kyusen_judgement
        if @container.turn_info.display_turn >= MIN_TURN
          if turn = @container.outbreak_turn
            if turn < Stat::OUTBREAK_TURN_AVG
              key = "急戦"
            else
              key = "持久戦"
            end
            @container.players.each do |e|
              e.skill_set.list_push(Analysis::NoteInfo[key])
            end
          end
        end
      end

      def tantesuu_judgement
        if @container.turn_info.display_turn >= MIN_TURN
          if @container.critical_turn # 1回でも駒の交換があった
            max = @container.turn_info.display_turn
            if max >= MIN_TURN
              if max < Stat::TURN_MAX_AVG
                key = "短手数"
              else
                key = "長手数"
              end
              @container.players.each do |e|
                e.skill_set.list_push(Analysis::NoteInfo[key])
              end
            end
          end
        end
      end

      def header_write
        Analysis::TacticInfo.each do |e|
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
