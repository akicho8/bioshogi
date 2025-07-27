require "#{__dir__}/setup"
Analysis::AbbrevExpander.expand("向飛車")     # => ["向飛車", "向かい飛車", "向飛車戦法", "向飛車囲い", "向飛車流", "向飛車型"]
Analysis::AbbrevExpander.expand("向飛車戦法") # => ["向飛車戦法", "向かい飛車戦法", "向飛車囲い", "向飛車流", "向飛車型", "向飛車"]
Analysis::AbbrevExpander.expand("")           # => []
