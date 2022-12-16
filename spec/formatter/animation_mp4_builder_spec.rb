require "spec_helper"

module Bioshogi
  module Formatter
    describe AnimationMp4Builder, animation: true do
      include AnimationSupport

      def test1(params = {})
        video, audio = target1(:mp4, :to_animation_mp4, **params)
        assert { video[:codec_name]       == "h264"    }
        assert { video[:r_frame_rate]     == "2/1"     }
        assert { video[:duration].to_f    == 3.0       }
        assert { video[:pix_fmt]          == "yuv420p" }

        assert { audio[:codec_name]       == "aac"     }
        assert { audio[:sample_rate].to_f == 44100     }
        assert { audio[:channels]         == 2         }
        assert { audio[:time_base]        == "1/44100" }
        assert { audio[:duration].to_f    == 3.018005  }
        assert { (120..140).cover?(audio[:bit_rate].to_f.fdiv(1024)) } # 128k
      end

      it "ffmpeg-version" do
        test1(factory_method_key: "is_factory_method_ffmpeg")
      end

      it "rmagick-version" do
        test1(factory_method_key: "is_factory_method_rmagick")
      end

      it "クロスフェイドあり" do
        info = Parser.parse("position startpos moves 7g7f 3c3d 8h2b+ 8c8d 2b3a 8d8e 3a4a 8e8f 4a5a")
        bin = info.to_animation_mp4(page_duration: 1.0, end_duration: 2, width: 2, height: 2)
        filename = Pathname("_outout.zip")
        filename.write(bin)
        video, audio = Media.streams(filename)
        pp audio if $0 == "-"
        assert { audio[:duration].to_i == 1 + 9 + 2 } # ぴったり 12 秒にはならないため to_i している
      end
    end
  end
end
