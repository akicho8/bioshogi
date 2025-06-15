# -*- compile-command: "rake v" -*-

module Bioshogi
  module Analysis
    class TacticDetector
      def call
        @rows = TagIndex.values.flat_map do |e|
          e.reference_files.collect do |file|
            SingleValidator.new(e, file).call
          end
        end
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
        def initialize(item, file)
          @item = item
          @file = file
        end

        def call
          row = { "合致" => "", key: @item.key }
          if @file
            row[:file] = @file.basename.to_s
            str = @file.read
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
