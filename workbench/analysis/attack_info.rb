require "#{__dir__}/setup"
# Analysis::AttackInfo.find_all { |e| e.group_key == "右玉" } # => [<右玉>, <矢倉右玉>, <糸谷流右玉>, <羽生流右玉>, <角換わり右玉>, <雁木右玉>, <リッチブリッジ>, <ツノ銀型右玉>, <三段右玉>, <清野流岐阜戦法>, <風車>, <新風車>]
# tag = Analysis::AttackInfo.fetch("原始中飛車")
# [tag, *tag.children].collect(&:name)            # => ["原始中飛車", "カニカニ銀", "▲5五龍中飛車", "鬼六流どっかん飛車"]

puts Analysis::AttackInfo.ancestors  # => nil
# >> Bioshogi::Analysis::AttackInfo
# >> Bioshogi::Analysis::TagMethods
# >> Bioshogi::Analysis::StyleAccessor
# >> Bioshogi::Analysis::StaticKifMod
# >> TreeSupport::Stringify
# >> TreeSupport::Treeable
# >> Bioshogi::Analysis::TreeMod
# >> Bioshogi::Analysis::BasicAccessor
# >> Bioshogi::Analysis::ShapeInfoAccessor
# >> #<Module:0x000000011cc6ab48>
# >> MemoryRecord::Serialization
# >> MemoryRecord::SingletonMethods
# >> Comparable
# >> MemoryRecord
# >> Bioshogi::ApplicationMemoryRecord
# >> Object
# >> PP::ObjectMixin
# >> Bioshogi
# >> ActiveSupport::Configurable
# >> ActiveSupport::ToJsonWithActiveSupportEncoder
# >> JSON::Ext::Generator::GeneratorMethods::Object
# >> ActiveSupport::Tryable
# >> Kernel
# >> BasicObject
