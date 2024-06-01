require "./setup"

Pathname.glob("../../2chkifu/**/*.{ki2,KI2}") do |file|
  file = file.expand_path
  s = file.read.toutf8
  if s.match?(/^手合.*：.*落/)
    if s.scan(/^(下手|上手)：/).flatten == ["下手", "上手"]
    else
      puts file
    end
    if s.match?(/^△/)
    else
      puts file
    end
  end
end
# >> /Users/ikeda/src/2chkifu/30000/34930.KI2
# >> /Users/ikeda/src/2chkifu/30000/37591.KI2
# >> /Users/ikeda/src/2chkifu/30000/39471.KI2
