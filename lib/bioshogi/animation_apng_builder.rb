module Bioshogi
  class AnimationApngBuilder < AnimationGifBuilder
    def ext_name
      "apng"
    end

    # apng も普通に変換すると1枚目のパレットで全体が決まってしまう
    # だけど PNG24 で保存するようにしたのでこれは必要ない
    # けど一応いれとこう
    def ffmpeg_option_fine_tune_for_each_file_type
      "-pix_fmt rgb24"
    end
  end
end
