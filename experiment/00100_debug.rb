require "./example_helper"

@params = {pieces_add: "飛 角 銀"}
@params.update({init: [
      "______", "______", "______",
      "______", "______", "______",
      "６六銀", "５六銀", "______",
    ]})
Mediator.read_spec(@params.merge(exec: "５五銀打")) # => ["５五銀打", "５五銀打"]
