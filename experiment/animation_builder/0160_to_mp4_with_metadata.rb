require "../example_helper"
info = Parser.parse("position startpos moves 7g7f 3c3d")
bin = info.to_mp4
Pathname("_output.mp4").write(bin)
tp Media.tags("_output.mp4")

bin = info.to_mp4(metadata_title: "(my タイトル)", metadata_comment: "(my\nコメント)")
Pathname("_output.mp4").write(bin)
tp Media.tags("_output.mp4")
# >> |-------------------+-----------------------------------|
# >> |       major_brand | isom                              |
# >> |     minor_version | 512                               |
# >> | compatible_brands | isomiso2avc1mp41                  |
# >> |             title | 2手目までの棋譜                   |
# >> |           encoder | Lavf58.76.100                     |
# >> |           comment | position startpos moves 7g7f 3c3d |
# >> |-------------------+-----------------------------------|
# >> |-------------------+------------------|
# >> |       major_brand | isom             |
# >> |     minor_version | 512              |
# >> | compatible_brands | isomiso2avc1mp41 |
# >> |             title | (my タイトル)    |
# >> |           encoder | Lavf58.76.100    |
# >> |           comment | (my\nコメント)   |
# >> |-------------------+------------------|
