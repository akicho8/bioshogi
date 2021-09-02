require "spec_helper"

module Bioshogi
  describe Mp4Formatter do
    it "works" do
      info = Parser.parse("position startpos moves 7g7f 8c8d")
      bin = info.to_mp4(one_frame_duration_sec: 0.5, end_frames: 0)
      File.write("_outout.mp4", bin)
      attrs = JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner -i _outout.mp4`)
      pp attrs if $0 == "-"
      video = attrs["streams"][0]
      assert { video["r_frame_rate"] == "2/1"  }
      assert { video["duration"] == "1.500000" }
      assert { video["pix_fmt"] == "yuv420p"   }
      assert { video["codec_name"] == "h264"   }
      FileUtils.rm_f("_outout.mp4")
    end
  end
end
# >> {"streams"=>
# >>   [{"index"=>0,
# >>     "codec_name"=>"h264",
# >>     "codec_long_name"=>"H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
# >>     "profile"=>"High",
# >>     "codec_type"=>"video",
# >>     "codec_tag_string"=>"avc1",
# >>     "codec_tag"=>"0x31637661",
# >>     "width"=>1200,
# >>     "height"=>630,
# >>     "coded_width"=>1200,
# >>     "coded_height"=>630,
# >>     "closed_captions"=>0,
# >>     "has_b_frames"=>2,
# >>     "pix_fmt"=>"yuv420p",
# >>     "level"=>31,
# >>     "chroma_location"=>"left",
# >>     "refs"=>1,
# >>     "is_avc"=>"true",
# >>     "nal_length_size"=>"4",
# >>     "r_frame_rate"=>"2/1",
# >>     "avg_frame_rate"=>"2/1",
# >>     "time_base"=>"1/16384",
# >>     "start_pts"=>0,
# >>     "start_time"=>"0.000000",
# >>     "duration_ts"=>24576,
# >>     "duration"=>"1.500000",
# >>     "bit_rate"=>"298112",
# >>     "bits_per_raw_sample"=>"8",
# >>     "nb_frames"=>"3",
# >>     "disposition"=>
# >>      {"default"=>1,
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
# >>       "timed_thumbnails"=>0},
# >>     "tags"=>
# >>      {"language"=>"und",
# >>       "handler_name"=>"VideoHandler",
# >>       "vendor_id"=>"[0][0][0][0]"}},
# >>    {"index"=>1,
# >>     "codec_name"=>"aac",
# >>     "codec_long_name"=>"AAC (Advanced Audio Coding)",
# >>     "profile"=>"LC",
# >>     "codec_type"=>"audio",
# >>     "codec_tag_string"=>"mp4a",
# >>     "codec_tag"=>"0x6134706d",
# >>     "sample_fmt"=>"fltp",
# >>     "sample_rate"=>"44100",
# >>     "channels"=>2,
# >>     "channel_layout"=>"stereo",
# >>     "bits_per_sample"=>0,
# >>     "r_frame_rate"=>"0/0",
# >>     "avg_frame_rate"=>"0/0",
# >>     "time_base"=>"1/44100",
# >>     "start_pts"=>0,
# >>     "start_time"=>"0.000000",
# >>     "duration_ts"=>66150,
# >>     "duration"=>"1.500000",
# >>     "bit_rate"=>"126384",
# >>     "nb_frames"=>"66",
# >>     "disposition"=>
# >>      {"default"=>1,
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
# >>       "timed_thumbnails"=>0},
# >>     "tags"=>
# >>      {"language"=>"eng",
# >>       "handler_name"=>"SoundHandler",
# >>       "vendor_id"=>"[0][0][0][0]"}}]}
# >> .
# >> 
# >> Finished in 4.43 seconds (files took 1.32 seconds to load)
# >> 1 example, 0 failures
# >> 
