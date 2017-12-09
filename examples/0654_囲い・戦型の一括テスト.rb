require "./example_helper"

hash = Hash.new(0)
SkillGroupInfo.each do |group|
  group.model.each do |e|
    if true
      kif = Pathname("#{group.name}/#{e.key}.kif")
      unless kif.exist?
        kif.write("")
      end
    end

    # if e.key != :"ダイヤモンド美濃"
    #   next
    # end

    files = Pathname.glob("#{group.name}/#{e.key}.*")
    # puts files

    mark = nil
    if files.empty? || files.all?{|e|e.read.blank?}
      mark = "SKIP"
    else
      files.each do |file|
        str = file.read
        if str.present?
          info = Parser.parse(str)
          info.mediator_run
          list = info.mediator.players.collect {|e| e.skill_set.to_h.values }.flatten
          if list.include?(e.key)
            mark = "OK"
          else
            mark = "ERROR"
          end
          puts "#{mark}: #{e.key} #{list.inspect}"
        end
      end
    end
    hash[mark] += 1
  end
end
p hash
