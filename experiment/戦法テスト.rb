require "./setup"

rows = []
Explain::TacticInfo.all_elements.each do |e|
  file = e.sample_kif_or_ki2_file
  row = { "合致" => "", key: e.key, file: file.basename.to_s }
  if e.tactic_info.key == :attack || true
    if file
      str = file.read
      info = Parser.parse(str)
      info.formatter.xcontainer_run_once
      info.formatter.xcontainer.players.each { |player|
        keys = player.skill_set.list_of(e).normalize.collect(&:key)
        row[player.location.key] = keys
      }
      info.formatter.xcontainer.players.each { |player|
        if row[player.location.key].include?(e.key)
          row["合致"] += player.location.mark
        end
      }
    else
      row["合致"] = "skip"
    end
    rows << row
  end
end
p rows.all? { |e| e["合致"].present? }      # => 
tp rows
