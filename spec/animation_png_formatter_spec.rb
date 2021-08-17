require "spec_helper"

module Bioshogi
  describe AnimationPngFormatter do
    it "works" do
      info = Parser.parse("position startpos moves 7g7f 8c8d")
      bin = info.to_animation_png(one_frame_duration: 0.5, end_frames: 0)
      File.write("_outout.apng", bin)
      attrs = JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner -i _outout.apng`)
      pp attrs if $0 == "-"
      video = attrs["streams"][0]
      assert { video["codec_name"] == "apng"  }
      assert { video["r_frame_rate"] == "25/1"  } # どゆこと？？？
      FileUtils.rm_f("_outout.apng")
    end
  end
end
# >> {"streams"=>
# >>   [{"index"=>0,
# >>     "codec_name"=>"apng",
# >>     "codec_long_name"=>"APNG (Animated Portable Network Graphics) image",
# >>     "codec_type"=>"video",
# >>     "codec_tag_string"=>"[0][0][0][0]",
# >>     "codec_tag"=>"0x0000",
# >>     "width"=>1200,
# >>     "height"=>630,
# >>     "coded_width"=>1200,
# >>     "coded_height"=>630,
# >>     "closed_captions"=>0,
# >>     "has_b_frames"=>0,
# >>     "pix_fmt"=>"rgba64be",
# >>     "level"=>-99,
# >>     "color_range"=>"pc",
# >>     "refs"=>1,
# >>     "r_frame_rate"=>"25/1",
# >>     "avg_frame_rate"=>"25/1",
# >>     "time_base"=>"1/100000",
# >>     "disposition"=>
# >>      {"default"=>0,
# >>       "dub"=>0,
# >>       "original"=>0,
# >>       "comment"=>0,
# >>       "lyrics"=>0,
# >>       "karaoke"=>0,
# >>       "forced"=>0,
# >>       "hearing_impaired"=>0,
# >>       "visual_impaired"=>0,
# >>       "clean_effects"=>0,
# >>       "attached_pic"=>0,
# >>       "timed_thumbnails"=>0}}]}
# >> .
# >> 
# >> Finished in 3.16 seconds (files took 1.41 seconds to load)
# >> 1 example, 0 failures
# >> 
