require "./setup"
Bioshogi::Analysis::TacticHitTurnTableGenerator.new.call

# e = Bioshogi::Analysis::TacticInfo.flat_lookup("大駒コンプリート") # => <大駒コンプリート>
# e.sample_kif_info.formatter.container.hand_logs.each do |e|
#   p e.to_kif
#   p e.skill_set
# end
# puts e.sample_kif_info.to_kif

# hand_logs = e.sample_kif_info.formatter.container.hand_logs   # =>
# tp hand_logs
#   turn = nil
#   e.sample_kif_info.formatter.container.hand_logs.each.with_index do |hand_log, i|
#     if hand_log.skill_set.flat_map { |e| e.flat_map(&:key) }.include?(e.key)
#       turn = i.next
#       break
#     end
#   end
#   [e, turn]
# end
# # 
# >> write: /Users/ikeda/src/bioshogi/lib/bioshogi/analysis/tactic_hit_turn_table.rb
