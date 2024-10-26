require "./setup"
info = Parser.parse("48玉 34歩 76歩 88角成")
# info.container.players.count    # => 2

# skill_set = info.container.players[0].skill_set
# skills = skill_set.attack_infos + skill_set.defense_infos
# skills.collect(&:name)                            # => ["新米長玉", "角交換型", "手得角交換型"]
# main_style_info = skills.collect { |e| e.style_info }.max  # => <変態>
#
# p info.pi.header

exit
tp Bioshogi::Analysis::DefenseInfo.styles_hash
tp Bioshogi::Analysis::DefenseInfo["美濃囲い"].style_info # =>
tp Bioshogi::Analysis::DefenseInfo["美濃囲い"].frequency  # =>
tp Bioshogi::Analysis::DefenseInfo["居玉"].style_info     # =>
tp Bioshogi::Analysis::DefenseInfo["居玉"].frequency      # =>
# ~> -:9:in `<main>': undefined method `last' for <変態>:Bioshogi::Analysis::StyleInfo (NoMethodError)
