require "./example_helper"

hash = Hash.new(0)
SkillGroupInfo.each do |group|
  group.model.each do |e|
    files = Pathname.glob("#{group.name}/#{e.key}_*.*")
    mark = nil
    if files.empty?
      mark = "SKIP"
    else
      flag = files.all? do |file|
        info = Parser.parse(file.read)
        info.mediator_run
        list = info.mediator.players.collect {|e| e.skill_set.to_h.values }.flatten
        list.include?(e.key)
      end
      if flag
        mark = "OK"
      else
        mark = "ERROR"
      end
      puts "#{mark}: #{e.key}"
    end
    hash[mark] += 1
  end
end
p hash
