require "../setup"
Analysis::DefenseInfo["紙穴熊"].add_to_self # => <穴熊>
Analysis::DefenseInfo["振り飛車穴熊"].add_to_self # => <穴熊>
Analysis::DefenseInfo.anaguma_elems # => [<片穴熊>, <居飛車穴熊>, <松尾流穴熊>, <神吉流穴熊>, <銀冠穴熊>, <居飛穴音無しの構え>, <ビッグ4>, <四枚穴熊>, <矢倉穴熊>, <紙穴熊>, <振り飛車穴熊>, <振り飛車銀冠穴熊>, <振り飛車ビッグ4>]

Analysis::DefenseInfo["紙穴熊"].only_preset_attr         # => :hirate_like
Analysis::AttackInfo["棒銀"].only_preset_attr            # => :hirate_like
Analysis::NoteInfo["居飛車"].only_preset_attr            # => :hirate_like
Analysis::TechniqueInfo["割り打ちの銀"].only_preset_attr # => :hirate_like
