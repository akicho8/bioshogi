# frozen-string-literal: true

module Bioshogi
  module Formatter
    class SkillEmbed
      MIN_TURN = 14

      attr_accessor :xparser
      attr_accessor :container

      def initialize(xparser, container)
        @xparser = xparser
        @container = container
      end

      def call
        rikisen_judgement

        # 両方が入玉していれば「相入玉」タグを追加する
        # この場合、両方同時に入玉しているかどうかは判定できない
        ainyugyoku_judgement

        if @xparser.preset_info
          if @xparser.preset_info.special_piece
            ibisha_judgement # 振り飛車でなければ居飛車
            aiibisha_judgement              # 両方居飛車なら相居飛車
            aihuri_judgement                # 両方振り飛車なら相振り
            taihuri_judgement               # 片方だけが「振り飛車」なら、振り飛車ではない方に「対振り」。両方に「対抗型」
            haisui_judgement                # 大駒がない状態で勝ったら「背水の陣」
          end
          igyoku_judgement                  # 居玉判定
          aiigyoku_judgement                # 相居玉判定
        end

        header_write # ヘッダーに埋める
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

      def aihuri_judgement
        # 両方振り飛車なら相振り
        if @container.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
          @container.players.each do |player|
            player.skill_set.list_push(Explain::NoteInfo["相振り"])
          end
        end
      end

      def taihuri_judgement
        # 片方だけが「振り飛車」なら、振り飛車ではない方に「対振り」。両方に「対抗型」
        if player = @container.players.find { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
          others = @container.players - [player]
          if others.none? { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
            others.each { |e| e.skill_set.list_push(Explain::NoteInfo["対振り"]) }
            @container.players.each { |e| e.skill_set.list_push(Explain::NoteInfo["対抗型"]) }
          end
        end
      end

      # 大駒がない状態で勝ったら「背水の陣」
      def haisui_judgement
        @container.players.each do |player|
          if player == @container.win_player
            if player.stronger_piece_have_count.zero?
              player.skill_set.list_push(Explain::NoteInfo["背水の陣"])
            end
          end
        end
      end

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

      def header_write
        # ヘッダーに埋める
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
