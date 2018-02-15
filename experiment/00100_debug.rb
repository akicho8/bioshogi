require "./example_helper"

@params = {pieces_add: "飛 角 銀"}
@params.update({init: [
      "______", "______", "______",
      "______", "______", "______",
      "______", "５六銀", "______",
    ]})
p Mediator.read_spec(@params.merge(exec: "５五銀打"))
# >> |----------|
# >> | ５五銀打 |
# >> |----------|
# >> |-----------------+-------|
# >> |      point_from |       |
# >> |           point | ５五  |
# >> |           piece | 銀    |
# >> |        promoted | false |
# >> | promote_trigger | false |
# >> |  direct_trigger | true  |
# >> |-----------------+-------|
# >> ["５五銀打", "５五銀打"]
