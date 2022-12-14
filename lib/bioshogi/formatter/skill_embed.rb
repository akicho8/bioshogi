# frozen-string-literal: true

module Bioshogi
  module Formatter
    class SkillEmbed
      attr_accessor :xparser
      attr_accessor :xcontainer

      def initialize(xparser, xcontainer)
        @xparser = xparser
        @xcontainer = xcontainer
      end

      def perform
        rikisen_hantei

        # 両方が入玉していれば「相入玉」タグを追加する
        # この場合、両方同時に入玉しているかどうかは判定できない
        ainyugyoku_check

        if @xparser.preset_info
          if @xparser.preset_info.special_piece
            ibisha_check # 振り飛車でなければ居飛車
            aiibisha_check              # 両方居飛車なら相居飛車
            aihuri_check                # 両方振り飛車なら相振り
            taihuri_check               # 片方だけが「振り飛車」なら、振り飛車ではない方に「対振り」。両方に「対抗型」
            haisui_check                # 大駒がない状態で勝ったら「背水の陣」
          end
          igyoku_check                  # 居玉判定
          aiigyoku_check                # 相居玉判定
        end

        header_write # ヘッダーに埋める
      end

      private

      def rikisen_hantei
        # return if ENV["BIOSHOGI_ENV"] == "test"
        if @xcontainer.turn_info.display_turn >= MIN_TURN
          # @xcontainer.players.each do |player|
          #   if player.skill_set.power_battle?
          #     ChaosInfo.each do |chaos_info|
          #       if chaos_info.if_cond[@xcontainer]
          #         player.skill_set.list_push(AttackInfo[chaos_info.key])
          #         break
          #       end
          #     end
          #   end
          # end
          # if @xcontainer.players.all? { |e| e.skill_set.power_battle? }
          #   @xcontainer.players.each do |e|
          #     e.skill_set.list_push(AttackInfo["乱戦"])
          #   end
          # else
          @xcontainer.players.each do |e|
            e.skill_set.rikisen_check_process
          end
          # end
        end
      end

      def ainyugyoku_check
        if @xcontainer.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["入玉"]) }
          @xcontainer.players.each do |player|
            player.skill_set.list_push(Explain::NoteInfo["相入玉"])
          end
        end
      end

      # 振り飛車でなければ居飛車
      def ibisha_check
        @xcontainer.players.each do |e|
          skill_set = e.skill_set
          if !skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) && !skill_set.has_skill?(Explain::NoteInfo["居飛車"])
            e.skill_set.list_push(Explain::NoteInfo["居飛車"])
          end
        end
      end

      def aiibisha_check
        # 両方居飛車なら相居飛車
        if @xcontainer.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["居飛車"]) }
          @xcontainer.players.each do |player|
            player.skill_set.list_push(Explain::NoteInfo["相居飛車"])
          end
        end
      end

      def aihuri_check
        # 両方振り飛車なら相振り
        if @xcontainer.players.all? { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
          @xcontainer.players.each do |player|
            player.skill_set.list_push(Explain::NoteInfo["相振り"])
          end
        end
      end

      def taihuri_check
        # 片方だけが「振り飛車」なら、振り飛車ではない方に「対振り」。両方に「対抗型」
        if player = @xcontainer.players.find { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
          others = @xcontainer.players - [player]
          if others.none? { |e| e.skill_set.has_skill?(Explain::NoteInfo["振り飛車"]) }
            others.each { |e| e.skill_set.list_push(Explain::NoteInfo["対振り"]) }
            @xcontainer.players.each { |e| e.skill_set.list_push(Explain::NoteInfo["対抗型"]) }
          end
        end
      end

      # 大駒がない状態で勝ったら「背水の陣」
      def haisui_check
        @xcontainer.players.each do |player|
          if player == @xcontainer.win_player
            if player.stronger_piece_have_count.zero?
              player.skill_set.list_push(Explain::NoteInfo["背水の陣"])
            end
          end
        end
      end

      def igyoku_check
        @xcontainer.players.each do |e|
          enabled = false
          # 14手以上の対局で一度も動かずに終了した
          if !enabled
            if @xcontainer.turn_info.display_turn >= MIN_TURN && e.king_moved_counter.zero?
              enabled = true
            end
          end
          # 歩と角以外の交換があったか？
          if !enabled
            if @xcontainer.outbreak_turn
              v = e.king_first_moved_turn
              if v.nil? || v >= @xcontainer.outbreak_turn  # 玉は動いていない、または戦いが激しくなってから動いた
                enabled = true
              end
            end
          end
          if enabled
            e.skill_set.list_push(Explain::DefenseInfo["居玉"])
          end
        end
      end

      def aiigyoku_check
        # 両方居玉だったら備考に相居玉
        if @xcontainer.players.all? { |e| e.skill_set.has_skill?(Explain::DefenseInfo["居玉"]) }
          @xcontainer.players.each do |e|
            e.skill_set.list_push(Explain::NoteInfo["相居玉"])
          end
        end
        # end
      end

      def header_write
        # ヘッダーに埋める
        Explain::TacticInfo.each do |e|
          @xcontainer.players.each do |player|
            list = player.skill_set.public_send(e.list_key).normalize
            if v = list.presence
              v = v.uniq # 手筋の場合、複数になる場合があるので uniq する
              key = "#{player.call_name}の#{e.name}"
              @xparser.skill_set_hash[key] = v.collect(&:name)
            end
          end
        end
        hv = @xparser.skill_set_hash.transform_values { |e| e.join(", ") }
        @xparser.header.object.update(hv)
      end
    end
  end
end
