require "spec_helper"

module Bioshogi
  describe AnimationGifFormatter do
    it "works" do
      info = Parser.parse("position startpos moves 7g7f 8c8d")
      bin = info.to_animation_gif(video_speed: 0.5, end_frames: 0)
      File.write("_outout.gif", bin)
      attrs = JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner -i _outout.gif`)
      pp attrs if $0 == "-"
      video = attrs["streams"][0]
      assert { video["r_frame_rate"] == "2/1"  }
      assert { video["duration"] == "1.500000" }
      FileUtils.rm_f("_outout.gif")
    end
  end
end
# >> {"streams"=>
# >>   [{"index"=>0,
# >>     "codec_name"=>"gif",
# >>     "codec_long_name"=>"CompuServe GIF (Graphics Interchange Format)",
# >>     "codec_type"=>"video",
# >>     "codec_tag_string"=>"[0][0][0][0]",
# >>     "codec_tag"=>"0x0000",
# >>     "width"=>1200,
# >>     "height"=>630,
# >>     "coded_width"=>1200,
# >>     "coded_height"=>630,
# >>     "closed_captions"=>0,
# >>     "has_b_frames"=>0,
# >>     "pix_fmt"=>"bgra",
# >>     "level"=>-99,
# >>     "refs"=>1,
# >>     "r_frame_rate"=>"2/1",
# >>     "avg_frame_rate"=>"2/1",
# >>     "time_base"=>"1/100",
# >>     "start_pts"=>0,
# >>     "start_time"=>"0.000000",
# >>     "duration_ts"=>150,
# >>     "duration"=>"1.500000",
# >>     "nb_frames"=>"3",
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
# >> Finished in 0.80527 seconds (files took 1.3 seconds to load)
# >> 1 example, 0 failures
# >> 
