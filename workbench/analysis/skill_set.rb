require "#{__dir__}/setup"
tag_bundle = Bioshogi::Analysis::TagBundle.new
tag_bundle.attack_infos << Bioshogi::Analysis::AttackInfo["コーヤン流三間飛車"]
tag_bundle.attack_infos << Bioshogi::Analysis::AttackInfo["嬉野流"]
tag_bundle.defense_infos << Bioshogi::Analysis::DefenseInfo["片美濃囲い"]
tag_bundle.defense_infos << Bioshogi::Analysis::DefenseInfo["銀美濃"]
tag_bundle.defense_infos << Bioshogi::Analysis::DefenseInfo["ダイヤモンド美濃"]
tp tag_bundle.attack_infos
tp tag_bundle.defense_infos
tag_bundle.normalized_names_with_alias # => ["コーヤン流三間飛車", "コーヤン流", "中田功XP", "嬉野流", "片美濃囲い", "銀美濃", "ダイヤモンド美濃"]
# >> |--------------------|
# >> | コーヤン流三間飛車 |
# >> | 嬉野流             |
# >> |--------------------|
# >> |------------------|
# >> | 片美濃囲い       |
# >> | 銀美濃           |
# >> | ダイヤモンド美濃 |
# >> |------------------|
# >> <コーヤン流三間飛車>
# >> <嬉野流>
# >> <片美濃囲い>
# >> <銀美濃>
# >> <ダイヤモンド美濃>
