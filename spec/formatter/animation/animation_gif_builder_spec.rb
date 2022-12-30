require "spec_helper"

module Bioshogi
  module Formatter
    module Animation
      describe AnimationGifBuilder, animation: true do
        include AnimationSupport

        describe "gif" do
          def test1(params = {})
            video, audio = target1(:gif, :to_animation_gif, **params)
            assert { video[:codec_name]    == "gif" }
            assert { video[:duration].to_f == 3     }
            assert { video[:r_frame_rate]  == "2/1" }
          end

          it "ffmpeg-version" do
            test1(factory_method_key: "is_factory_method_ffmpeg")
          end

          it "rmagick-version" do
            test1(factory_method_key: "is_factory_method_rmagick")
          end
        end

        it "apng" do
          video, audio = target1(:apng, :to_animation_apng)
          assert { video[:codec_name] == "apng"  }
          assert { video[:r_frame_rate] == "2/1"  }
        end

        it "webp" do
          video, audio = target1(:webp, :to_animation_webp)
          assert { video[:codec_name] == "webp"  }
          assert { video[:r_frame_rate] == "25/1"  } # なんで 2/1 じゃない？
        end
      end
    end
  end
end
