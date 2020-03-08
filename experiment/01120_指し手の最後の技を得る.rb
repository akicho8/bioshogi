require "./example_helper"

mediator = Mediator.start
mediator.params[:skill_monitor_enable] = true

# 最後の手に技が入っている
mediator.execute("68銀", executor_class: PlayerExecutorWithoutMonitor)
mediator.hand_logs.last.hand                   # => <▲６八銀(79)>
mediator.hand_logs.last.skill_set.attack_infos # => [<嬉野流>]

mediator.execute("34歩", executor_class: PlayerExecutorWithoutMonitor)
mediator.hand_logs.last.hand                   # => <△３四歩(33)>
mediator.hand_logs.last.skill_set.attack_infos # => []

mediator.execute("26歩", executor_class: PlayerExecutorWithoutMonitor)
mediator.hand_logs.last.hand                   # => <▲２六歩(27)>
mediator.hand_logs.last.skill_set.attack_infos # => []

# まとめて見る場合
mediator.player_at(:black).skill_set.attack_infos # => [<嬉野流>]
