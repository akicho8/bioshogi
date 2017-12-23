require "./example_helper"
# Bushido.config[:skill_set_flag] = false

log1 = Pathname("プロ棋士名前一覧.txt")
log2 = Pathname("プロ棋士階級一覧.txt")

players = []
grades = []
files = Pathname.glob("../../2chkifu/**/*.{ki2,KI2}").sort
files = files.take((ARGV.first || 1000_0000).to_i)

# files = "~/src/2chkifu/20000/26724.KI2"
files = "~/src/2chkifu/10000/15647.KI2"

Array(files).each do |file|
  file = Pathname(file).expand_path
  begin
    print "."

    info = Parser.file_parse(file, typical_error_case: :skip)
    # tp info.header
    # tp info.raw_header

    dirty_names = info.raw_header["vs"] || []
    # tp dirty_names

    # dirty_names = dirty_names.collect{|e|e.remove(/\p{blank}/)}

    names = Location.flat_map(&:call_names).collect {|e| info.raw_header[e] }.compact
    # names = names.collect{|e|e.remove(/\p{blank}/)}

    v = (players + names).sort.uniq
    if players.size < v.size
      players = v
      log1.write(players.join("\n"))
      print "1"
    end

    v = (grades + dirty_names.collect {|e| e.remove(*names) }).uniq.sort
    if grades.size < v.size
      grades = v
      log2.write(grades.join("\n"))
      print "2"
    end

    STDOUT.flush
  rescue => error
    puts
    puts file
    raise error
  end
end

log1.readlines # => ["今井　進\n", "古河彩子"]
log2.readlines # => ["今井進ミステリマガジン編集長（自称四段）\n", "女流二段"]
# >> .12
