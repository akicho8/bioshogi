require "#{__dir__}/setup"

# Pathname("/Users/ikeda/Downloads/石田流攻め筋集").glob("**/1.kif") do |e|
#   title = e.dirname.basename.to_s
#   e.read
# end
# exit

ANIMATION_OPTIONS = {
  :page_duration  => 2.0,
  :begin_pages    => nil,
  :begin_duration => 1.0,
  :end_pages      => nil,
  :end_duration   => 2.0,
  :turn_embed_key => "is_turn_embed_on",
}

records = (1..2).to_a

records.each do |name|
  sfen = "position startpos moves 7g7f"
  info = Parser.parse(sfen)
  options = ANIMATION_OPTIONS.merge(cover_text: "タイトル#{name}")
  bin = info.to_animation_mp4(options)
  Pathname("_output#{name}.mp4").write(bin)
end

body = records.collect { |e| "file '_output#{e}.mp4'" + "\n" }.join
Pathname("_filelist.txt").write(body)

system "ffmpeg -f concat -safe 0 -i _filelist.txt -c copy -y _output.mp4"
chrome "_output.mp4"
