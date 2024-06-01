require "./setup"

Parser::Daikon.split("花村元司")        # => ["花村元司"]
Parser::Daikon.split("花村元司元名人")  # => ["花村元司", "元", "名人"]
Parser::Daikon.split("花村元司元NHK杯") # => ["花村元司", "元", "NHK杯"]
Parser::Daikon.split("花村元司1級")     # => ["花村元司", "1級"]
Parser::Daikon.split("花村元司初段")    # => ["花村元司", "初段"]
Parser::Daikon.split("花村＆元司")      # => ["花村", "元司"]
Parser::Daikon.split("第007回花村")     # => ["第007回", "花村"]
