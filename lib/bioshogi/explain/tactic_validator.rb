# -*- compile-command: "rake v" -*-

module Bioshogi
  module Explain
    class TacticValidator
      def call
        rows = TacticInfo.all_elements.collect(&method(:process_one))
        puts
        tp rows
        puts rows.all? { |e| e["合致"].present? } ? "OK" : "ERROR"
      end

      private

      def process_one(e)
        file = e.sample_kif_or_ki2_file
        row = { "合致" => "", key: e.key }
        if file
          row[:file] = file.basename.to_s
          str = file.read
          info = Parser.parse(str)
          info.formatter.container_run_once
          info.formatter.container.players.each do |player|
            keys = player.skill_set.list_of(e).normalize.collect(&:key)
            row[player.location.key] = keys
          end
          info.formatter.container.players.each do |player|
            if row[player.location.key].include?(e.key)
              row["合致"] += player.location.mark
            end
          end
        end
        print row["合致"].present? ? "." : "E"
        row
      end
    end
  end
end
