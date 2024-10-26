# -*- compile-command: "rake v" -*-

module Bioshogi
  module Analysis
    class TacticValidator
      def call
        @rows = TacticInfo.all_elements.collect { |e| SingleValidator.new(e).call }
        puts
        tp @rows
        puts success? ? "OK" : "ERROR"
        tp errors
      end

      def errors
        @errors ||= @rows.find_all { |e| e["合致"] == "ERROR" }
      end

      def success?
        errors.none?
      end

      private

      class SingleValidator
        def initialize(item)
          @item = item
        end

        def call
          file = @item.sample_kif_or_ki2_file
          row = { "合致" => "", key: @item.key }
          if file
            # row[:file] = file.basename.to_s
            str = file.read
            info = Parser.parse(str)
            info.formatter.container_run_once
            info.formatter.container.players.each do |player|
              keys = player.skill_set.list_of(@item).normalize.collect(&:key)
              row[player.location.key] = keys
            end
            info.formatter.container.players.each do |player|
              if row[player.location.key].include?(@item.key)
                row["合致"] += player.location.mark
              end
            end
          end
          if row["合致"].blank?
            row["合致"] = "ERROR"
          end
          print row["合致"] == "ERROR" ? "E" : "."
          row
        end
      end
    end
  end
end
