require "./setup"

key = "原始棒銀"
info = Parser.file_parse("戦法/#{key}.kif")
info.formatter.container.hand_logs.each.with_index do |hand_log, i|
  if hand_log.skill_set.flat_map { |e| e.flat_map(&:key) }.include?(key.to_sym)
    p i.next
  end
end
# >> 7
