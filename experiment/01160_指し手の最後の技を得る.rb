require "./setup"

xcontainer = Xcontainer.start
xcontainer.params[:skill_monitor_enable] = true

# 最後の手に技が入っている
xcontainer.execute("68銀", executor_class: PlayerExecutorWithoutMonitor)
xcontainer.hand_logs.last.hand                   # => <▲６八銀(79)>
xcontainer.hand_logs.last.skill_set.attack_infos # => [<嬉野流>]

xcontainer.execute("34歩", executor_class: PlayerExecutorWithoutMonitor)
xcontainer.hand_logs.last.hand                   # => <△３四歩(33)>
xcontainer.hand_logs.last.skill_set.attack_infos # => []

xcontainer.execute("26歩", executor_class: PlayerExecutorWithoutMonitor)
xcontainer.hand_logs.last.hand                   # => <▲２六歩(27)>
xcontainer.hand_logs.last.skill_set.attack_infos # => []

# まとめて見る場合
xcontainer.player_at(:black).skill_set.attack_infos # => [<嬉野流>]
