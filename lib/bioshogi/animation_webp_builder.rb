module Bioshogi
  class AnimationWebpBuilder < AnimationGifBuilder
    def ext_name
      "webp"
    end

    def ffmpeg_option_fine_tune_for_each_file_type
    end
  end
end
