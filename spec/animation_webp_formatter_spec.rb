require "spec_helper"

module Bioshogi
  describe AnimationWebpFormatter do
    it "works" do
      info = Parser.parse("position startpos moves 7g7f 8c8d")
      bin = info.to_animation_webp(one_frame_duration_sec: 0.5, end_frames: 0)
      File.write("_outout.webp", bin)
      attrs = JSON.parse(`ffprobe -v quiet -print_format json -show_streams -hide_banner -i _outout.webp`) # XXX: -v quiet をつけないとエラーがでている
      pp attrs if $0 == "-"
      video = attrs["streams"][0]
      assert { video["codec_name"] == "webp"  }
      assert { video["r_frame_rate"] == "25/1"  } # ← 2/1 になるべき
      FileUtils.rm_f("_outout.webp")
    end
  end
end
# >> {"streams"=>
# >>   [{"index"=>0,
# >>     "codec_name"=>"webp",
# >>     "codec_long_name"=>"WebP",
# >>     "codec_type"=>"video",
# >>     "codec_tag_string"=>"[0][0][0][0]",
# >>     "codec_tag"=>"0x0000",
# >>     "width"=>0,
# >>     "height"=>0,
# >>     "coded_width"=>0,
# >>     "coded_height"=>0,
# >>     "closed_captions"=>0,
# >>     "has_b_frames"=>0,
# >>     "level"=>-99,
# >>     "refs"=>1,
# >>     "r_frame_rate"=>"25/1",
# >>     "avg_frame_rate"=>"25/1",
# >>     "time_base"=>"1/25",
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
# >> Finished in 2.54 seconds (files took 1.34 seconds to load)
# >> 1 example, 0 failures
# >> 
