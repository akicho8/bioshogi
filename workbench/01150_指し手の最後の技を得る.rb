require "./setup"

container = Container::Basic.start
container.params[:analysis_feature] = true

# 最後の手に技が入っている
container.execute("68銀", executor_class: PlayerExecutor::WithoutAnalyzer)
container.hand_logs.last.hand                   # => <▲６八銀(79)>
container.hand_logs.last.skill_set.attack_infos # => [<嬉野流>]

container.execute("34歩", executor_class: PlayerExecutor::WithoutAnalyzer)
container.hand_logs.last.hand                   # => <△３四歩(33)>
container.hand_logs.last.skill_set.attack_infos # => []

container.execute("26歩", executor_class: PlayerExecutor::WithoutAnalyzer)
container.hand_logs.last.hand                   # => <▲２六歩(27)>
container.hand_logs.last.skill_set.attack_infos # => []

# まとめて見る場合
container.player_at(:black).skill_set.attack_infos # => [<嬉野流>]
