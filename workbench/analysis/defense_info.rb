require "../setup"
Analysis::DefenseInfo["紙穴熊"].add_to_self       # => nil
Analysis::DefenseInfo["振り飛車穴熊"].add_to_self # => nil
Analysis::GroupInfo["穴熊"].values                # => [<穴熊>, <裸穴熊>, <一枚穴熊>, <二枚穴熊>, <三枚穴熊>, <四枚穴熊>, <五枚穴熊>, <六枚穴熊>, <七枚穴熊>, <八枚穴熊>, <居飛車穴熊>, <振り飛車穴熊>, <入玉穴熊>, <松尾流穴熊>, <神吉流穴熊>, <銀冠穴熊>, <居飛穴音無しの構え>, <ビッグ4>, <矢倉穴熊>, <角換わり穴熊>, <紙穴熊>, <振り飛車銀冠穴熊>, <振り飛車ビッグ4>]

Analysis::DefenseInfo["紙穴熊"].preset_is         # => :hirate_like
Analysis::AttackInfo["棒銀"].preset_is            # => :hirate_like
Analysis::NoteInfo["居飛車"].preset_is            # => nil
Analysis::TechniqueInfo["割り打ちの銀"].preset_is # => nil
