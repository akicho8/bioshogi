require "./setup"
Analysis::AttackInfo.find_all { |e| e.group_key == "右玉" } # => [<右玉>, <矢倉右玉>, <糸谷流右玉>, <羽生流右玉>, <角換わり右玉>, <雁木右玉>, <ツノ銀型右玉>, <三段右玉>, <清野流岐阜戦法>]
