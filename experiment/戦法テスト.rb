require "./setup"

rows = []
TacticInfo.all_elements.each do |e|
  file = Pathname.glob("#{__dir__}/../lib/bioshogi/#{e.tactic_info.name}/#{e.key}.{kif,ki2}").first
  row = { "合致" => "", key: e.key, file: file.basename.to_s }
  if e.tactic_info.key == :attack || true
    if file
      str = file.read
      info = Parser.parse(str)
      info.xcontainer_run_once
      info.xcontainer.players.each { |player|
        keys = player.skill_set.list_of(e).normalize.collect(&:key)
        row[player.location.key] = keys
      }
      info.xcontainer.players.each { |player|
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
# ~> -:6:in `block in <main>': undefined method `basename' for nil:NilClass (NoMethodError)
# ~> 	from -:4:in `each'
# ~> 	from -:4:in `<main>'
