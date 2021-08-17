module Media
  extend self

  def duration(file)
    info = JSON.parse(`ffprobe -v warning -print_format json -show_entries format=duration #{file}`)
    info["format"]["duration"].to_f
  end

  def bit_rate(file)
    info = JSON.parse(`ffprobe -v warning -print_format json -show_entries format=bit_rate #{file}`)
    info["format"]["bit_rate"].to_f
  end

  def pretty_inspect(file)
    JSON.parse(`ffprobe -v warning -pretty -print_format json -show_streams #{file}`)
  end

  def inspect(file)
    `ffprobe -hide_banner #{file} 2>&1 | grep Stream`
  end

  def p(file)
    puts inspect(file)
  end

  def format(file)
    JSON.parse(`ffprobe -v warning -pretty -print_format json -show_format #{file}`)["format"]
  end
end
