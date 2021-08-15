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
# >>     29150  08-15-2021 16:18   xxx0.png
# >>     30412  08-15-2021 16:18   xxx1.png
# >>     31763  08-15-2021 16:18   xxx2.png
# >> ---------                     -------
# >>     91325                     3 files
# >> .
# >> 
# >> Finished in 0.76117 seconds (files took 1.22 seconds to load)
# >> 1 example, 0 failures
# >> 
