require "spec_helper"

module Bioshogi
  module Formatter
    module Animation
      describe AnimationZipBuilder, animation: true do
        it "zip" do
          info = Parser.parse("position startpos moves 7g7f 8c8d")
          bin = info.to_animation_zip(cover_text: "(cover_text)", basename_format: "xxx%d")
          filename = Pathname(Tempfile.open(["", ".zip"]).path)
          filename.write(bin)
          puts `unzip -l #{filename}` if $0 == "-"
          Zip::InputStream.open(StringIO.new(bin)) do |zis|
            assert { zis.get_next_entry.name == "cover.png" }
            assert { zis.get_next_entry.name == "xxx0.png"  }
            assert { zis.get_next_entry.name == "xxx1.png"  }
          end
        end
      end
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 5 / 13 LOC (38.46%) covered.
# >> Archive:  /var/folders/9c/_62dfc8502g_d5r05zyfwlxh0000gp/T/20231106-25287-uc4mnz.zip
# >>   Length      Date    Time    Name
# >> ---------  ---------- -----   ----
# >>     14526  11-06-2023 16:37   cover.png
# >>    295911  11-06-2023 16:37   xxx0.png
# >>    299985  11-06-2023 16:37   xxx1.png
# >>    303611  11-06-2023 16:37   xxx2.png
# >> ---------                     -------
# >>    914033                     4 files
# >> .
# >>
# >> Top 1 slowest examples (1.01 seconds, 99.8% of total time):
# >>   Bioshogi::Formatter::Animation::AnimationZipBuilder zip
# >>     1.01 seconds -:7
# >>
# >> Finished in 1.02 seconds (files took 0.59795 seconds to load)
# >> 1 example, 0 failures
# >>
