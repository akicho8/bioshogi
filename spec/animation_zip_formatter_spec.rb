require "spec_helper"

module Bioshogi
  describe AnimationZipFormatter do
    it "works" do
      info = Parser.parse("position startpos moves 7g7f 8c8d")
      bin = info.to_animation_zip(basename_format: "xxx%d")
      File.write("_outout.zip", bin)
      puts `unzip -l _outout.zip` if $0 == "-"
      Zip::InputStream.open(StringIO.new(bin)) do |zis|
        entry = zis.get_next_entry
        assert { entry.name == "xxx0.png" }
      end
      FileUtils.rm_f("_outout.zip")
    end
  end
end
# >> Archive:  _outout.zip
# >>   Length      Date    Time    Name
# >> ---------  ---------- -----   ----
# >>     29150  08-23-2021 13:16   xxx0.png
# >>     32724  08-23-2021 13:16   xxx1.png
# >>     33344  08-23-2021 13:16   xxx2.png
# >> ---------                     -------
# >>     95218                     3 files
# >> .
# >> 
# >> Finished in 0.63957 seconds (files took 1.29 seconds to load)
# >> 1 example, 0 failures
# >> 
